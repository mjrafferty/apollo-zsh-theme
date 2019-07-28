# vim:ft=bash

[[ -o interactive ]] || return

autoload -Uz add-zsh-hook && zmodload zsh/datetime zsh/system || return

gitstatus_query() {

  emulate -L zsh
  setopt err_return no_unset

  local opt dir callback name client_pid_var req_fd_var
  local -F timeout
  local -i req_fd
  local -r req_id

  dir=${${GIT_DIR:-$PWD}:a}
  callback=''
  timeout=-1

  while true; do
    getopts "d:c:t:" opt || break
    case $opt in
      d) dir=$OPTARG;;
      c) callback=$OPTARG;;
      t) timeout=$OPTARG;;
      ?) return 1;;
      done) break;;
    esac
  done

  if (( OPTIND != ARGC )); then
    echo "usage: gitstatus_query [OPTION]... NAME" >&2;
    return 1;
  fi

  name=${*[$OPTIND]}

  [[ -n ${(P)${:-GITSTATUS_DAEMON_PID_${name}}:-} ]]

  # Verify that gitstatus_query is running in the same process that ran gitstatus_start.
  client_pid_var=_GITSTATUS_CLIENT_PID_${name}
  [[ ${(P)client_pid_var} == $$ ]]

  req_fd_var=_GITSTATUS_REQ_FD_${name}
  req_fd=${(P)req_fd_var}
  req_id="$EPOCHREALTIME"

  echo -nE "${req_id} ${callback}"$'\x1f'"${dir}"$'\x1e' >&$req_fd

  while true; do
    _gitstatus_process_response $name $timeout $req_id
    [[ $VCS_STATUS_RESULT == *-async ]] || break
  done

  [[ $VCS_STATUS_RESULT != tout || -n $callback ]]

}

_gitstatus_process_response() {

  emulate -L zsh
  setopt err_return no_unset

  local name req_id resp_fd_var
  local -F timeout
  local -i dirty_max_index_size ours
  local -a resp header

  name=$1
  timeout=$2
  req_id=$3
  resp_fd_var=_GITSTATUS_RESP_FD_${name}
  dirty_max_index_size=_GITSTATUS_DIRTY_MAX_INDEX_SIZE_${name}

  typeset -g VCS_STATUS_RESULT

  (( timeout >= 0 )) && local -a t=(-t $timeout) || local -a t=()

  IFS=$'\x1f' read -rd $'\x1e' -u ${(P)resp_fd_var} $t -A resp || {
    VCS_STATUS_RESULT=tout
    return
  }

  header=("${(@Q)${(z)resp[1]}}")

  [[ ${header[1]} == $req_id ]] && ours=1 || ours=0

  shift header

  if [[ ${resp[2]} == 1 ]]; then

    if (( ours )); then
      VCS_STATUS_RESULT=ok-sync
    else
      VCS_STATUS_RESULT=ok-async
    fi

    typeset -g  VCS_STATUS_WORKDIR="${resp[3]}"
    typeset -g  VCS_STATUS_COMMIT="${resp[4]}"
    typeset -g  VCS_STATUS_LOCAL_BRANCH="${resp[5]}"
    typeset -g  VCS_STATUS_REMOTE_BRANCH="${resp[6]}"
    typeset -g  VCS_STATUS_REMOTE_NAME="${resp[7]}"
    typeset -g  VCS_STATUS_REMOTE_URL="${resp[8]}"
    typeset -g  VCS_STATUS_ACTION="${resp[9]}"
    typeset -gi VCS_STATUS_INDEX_SIZE="${resp[10]}"
    typeset -gi VCS_STATUS_NUM_STAGED="${resp[11]}"
    typeset -gi VCS_STATUS_NUM_UNSTAGED="${resp[12]}"
    typeset -gi VCS_STATUS_NUM_UNTRACKED="${resp[13]}"
    typeset -gi VCS_STATUS_COMMITS_AHEAD="${resp[14]}"
    typeset -gi VCS_STATUS_COMMITS_BEHIND="${resp[15]}"
    typeset -gi VCS_STATUS_STASHES="${resp[16]}"
    typeset -g  VCS_STATUS_TAG="${resp[17]}"

    typeset -gi VCS_STATUS_HAS_STAGED=$((VCS_STATUS_NUM_STAGED > 0))

    if (( dirty_max_index_size >= 0 && VCS_STATUS_INDEX_SIZE > dirty_max_index_size )); then
      typeset -gi VCS_STATUS_HAS_UNSTAGED=-1
      typeset -gi VCS_STATUS_HAS_UNTRACKED=-1
    else
      typeset -gi VCS_STATUS_HAS_UNSTAGED=$((VCS_STATUS_NUM_UNSTAGED > 0))
      typeset -gi VCS_STATUS_HAS_UNTRACKED=$((VCS_STATUS_NUM_UNTRACKED > 0))
    fi

  else

    if (( ours )); then
      VCS_STATUS_RESULT=norepo-sync
    else
      VCS_STATUS_RESULT=norepo-async
    fi

    unset VCS_STATUS_WORKDIR
    unset VCS_STATUS_COMMIT
    unset VCS_STATUS_LOCAL_BRANCH
    unset VCS_STATUS_REMOTE_BRANCH
    unset VCS_STATUS_REMOTE_NAME
    unset VCS_STATUS_REMOTE_URL
    unset VCS_STATUS_ACTION
    unset VCS_STATUS_INDEX_SIZE
    unset VCS_STATUS_NUM_STAGED
    unset VCS_STATUS_NUM_UNSTAGED
    unset VCS_STATUS_NUM_UNTRACKED
    unset VCS_STATUS_HAS_STAGED
    unset VCS_STATUS_HAS_UNSTAGED
    unset VCS_STATUS_HAS_UNTRACKED
    unset VCS_STATUS_COMMITS_AHEAD
    unset VCS_STATUS_COMMITS_BEHIND
    unset VCS_STATUS_STASHES
    unset VCS_STATUS_TAG

  fi

  (( ! ours )) && (( ${#header} )) && emulate -L zsh && "${header[@]}" || true

}

gitstatus_start_impl() {

  if  [[ ${GITSTATUS_ENABLE_LOGGING:-0} == 1 ]]; then
    xtrace_file=$(mktemp "${TMPDIR:-/tmp}"/gitstatus.$$.xtrace.XXXXXXXXXX)
    typeset -g GITSTATUS_XTRACE_${name}=$xtrace_file
    exec {stderr_fd}>&2 2>$xtrace_file
    setopt xtrace
  fi

}

gitstatus_start() {

  emulate -L zsh

  setopt err_return no_unset no_bg_nice

  local opt
  local -F timeout=5
  local -i max_num_staged=1
  local -i max_num_unstaged=1
  local -i max_num_untracked=1
  local -i dirty_max_index_size=-1

  while true; do
    getopts "t:s:u:d:m:" opt || break
    case $opt in
      t) timeout=$OPTARG;;
      s) max_num_staged=$OPTARG;;
      u) max_num_unstaged=$OPTARG;;
      d) max_num_untracked=$OPTARG;;
      m) dirty_max_index_size=$OPTARG;;
      ?) return 1;;
    esac
  done

  if (( timeout <= 0 )); then
    echo "invalid -t: $timeout" >&2;
    return 1;
  fi

  if (( OPTIND != ARGC )); then
    echo "usage: gitstatus_start [OPTION]... NAME" >&2;
    return 1;
  fi

  local name=${*[$OPTIND]}

  if [[ ! -z ${(P)${:-GITSTATUS_DAEMON_PID_${name}}:-} ]]; then
    return 0;
  fi

  local dir && dir=${${(%):-%x}:A:h}
  local xtrace_file lock_file req_fifo resp_fifo log_file
  local -i stderr_fd=-1 lock_fd=-1 req_fd=-1 resp_fd=-1 daemon_pid=-1

    local os && os=$(uname -s) && [[ -n $os ]]
    [[ $os != Linux || $(uname -o) != Android ]] || os=Android
    local arch && arch=$(uname -m) && [[ -n $arch ]]

    local daemon=${GITSTATUS_DAEMON:-$dir/bin/gitstatusd-${os:l}-${arch:l}}
    [[ -f $daemon ]]

    lock_file=$(mktemp "${TMPDIR:-/tmp}"/gitstatus.$$.lock.XXXXXXXXXX)
    zsystem flock -f lock_fd $lock_file

    req_fifo=$(mktemp -u "${TMPDIR:-/tmp}"/gitstatus.$$.pipe.req.XXXXXXXXXX)
    mkfifo $req_fifo
    sysopen -rw -o cloexec,sync -u req_fd $req_fifo
    command rm -f $req_fifo

    resp_fifo=$(mktemp -u "${TMPDIR:-/tmp}"/gitstatus.$$.pipe.resp.XXXXXXXXXX)
    mkfifo $resp_fifo
    sysopen -rw -o cloexec -u resp_fd $resp_fifo
    command rm -f $resp_fifo

    function _gitstatus_process_response_${name}() {
      _gitstatus_process_response ${${(%)${:-%N}}#_gitstatus_process_response_} 0 ''
    }
    zle -F $resp_fd _gitstatus_process_response_${name}

    [[ ${GITSTATUS_ENABLE_LOGGING:-0} == 1 ]] &&
      log_file=$(mktemp "${TMPDIR:-/tmp}"/gitstatus.$$.daemon-log.XXXXXXXXXX) ||
      log_file=/dev/null
    typeset -g GITSTATUS_DAEMON_LOG_${name}=$log_file

    local -i threads=${GITSTATUS_NUM_THREADS:-0}
    (( threads > 0)) || {
      threads=8
      case $os in
        FreeBSD) (( ! $+commands[sysctl] )) || threads=$(( 2 * $(command sysctl -n hw.ncpu) ));;
        *) (( ! $+commands[getconf] )) || threads=$(( 2 * $(command getconf _NPROCESSORS_ONLN) ));;
      esac
      (( threads <= 32 )) || threads=32
    }

    # We use `zsh -c` instead of plain {} or () to work around bugs in zplug. It hangs on startup.
    zsh -dfxc "
      ${(q)daemon}                             \
        --lock-fd=3                            \
        --parent-pid=$$                        \
        --num-threads=$threads                 \
        --max-num-staged=$max_num_staged       \
        --max-num-unstaged=$max_num_unstaged   \
        --max-num-untracked=$max_num_untracked \
        --dirty-max-index-size=$dirty_max_index_size
      echo -nE $'bye\x1f0\x1e'
    " <&$req_fd >&$resp_fd 2>$log_file 3<$lock_file &!

    daemon_pid=$!
    command rm -f $lock_file

    local reply
    echo -nE $'hello\x1f\x1e' >&$req_fd
    IFS='' read -r -d $'\x1e' -u $resp_fd -t $timeout reply
    [[ $reply == $'hello\x1f0' ]]

    function _gitstatus_cleanup_${ZSH_SUBSHELL}_${daemon_pid}() {
      emulate -L zsh
      setopt err_return no_unset
      local fname=${(%):-%N}
      local prefix=_gitstatus_cleanup_${ZSH_SUBSHELL}_
      [[ $fname == ${prefix}* ]] || return 0
      local -i daemon_pid=${fname#$prefix}
      kill -- -$daemon_pid &>/dev/null || true
    }

    add-zsh-hook zshexit _gitstatus_cleanup_${ZSH_SUBSHELL}_${daemon_pid}

    [[ $stderr_fd == -1 ]] || {
      unsetopt xtrace
      exec 2>&$stderr_fd {stderr_fd}>&-
      stderr_fd=-1
    }
  }

gitstatus_stop() {

  emulate -L zsh

  setopt no_unset

  local name req_fd_var resp_fd_var lock_fd_var daemon_pid_var client_pid_var req_fd resp_fd lock_fd daemon_pid cleanup_func

  if (( ARGC != 1 )); then
    echo "usage: gitstatus_stop NAME" >&2;
    return 1;
  fi

  name=$1

  req_fd_var=_GITSTATUS_REQ_FD_${name}
  resp_fd_var=_GITSTATUS_RESP_FD_${name}
  lock_fd_var=_GITSTATUS_LOCK_FD_${name}
  daemon_pid_var=GITSTATUS_DAEMON_PID_${name}
  client_pid_var=_GITSTATUS_CLIENT_PID_${name}

  req_fd=${(P)req_fd_var:-}
  resp_fd=${(P)resp_fd_var:-}
  lock_fd=${(P)lock_fd_var:-}
  daemon_pid=${(P)daemon_pid_var:-}

  cleanup_func=_gitstatus_cleanup_${ZSH_SUBSHELL}_${daemon_pid}

  [[ -n $daemon_pid ]] && kill -- -$daemon_pid &>/dev/null
  [[ -n $req_fd     ]] && exec {req_fd}>&-
  [[ -n $resp_fd    ]] && { zle -F $resp_fd; exec {resp_fd}>&- }
  [[ -n $lock_fd    ]] && zsystem flock -u $lock_fd

  unset $req_fd_var $resp_fd_var $lock_fd_var $daemon_pid_var $client_pid_var

  if (( $+functions[$cleanup_func] )); then
    add-zsh-hook -d zshexit $cleanup_func
    unfunction $cleanup_func
  fi

  return 0

}


gitstatus_check() {

  emulate -L zsh

  if (( ARGC != 1 )); then
    echo "usage: gitstatus_check NAME" >&2;
    return 1;
  fi

  [[ -n ${(P)${:-GITSTATUS_DAEMON_PID_${1}}} ]]

}


if gitstatus_start_impl; then

  typeset -gi  GITSTATUS_DAEMON_PID_${name}=$daemon_pid
  typeset -gi _GITSTATUS_REQ_FD_${name}=$req_fd
  typeset -gi _GITSTATUS_RESP_FD_${name}=$resp_fd
  typeset -gi _GITSTATUS_LOCK_FD_${name}=$lock_fd
  typeset -gi _GITSTATUS_CLIENT_PID_${name}=$$
  typeset -gi _GITSTATUS_DIRTY_MAX_INDEX_SIZE_${name}=$dirty_max_index_size

  unset -f gitstatus_start_impl

else

  unsetopt err_return

  add-zsh-hook -d zshexit _gitstatus_cleanup_${ZSH_SUBSHELL}_${daemon_pid}

  [[ $daemon_pid -gt 0 ]] && kill -- -$daemon_pid &>/dev/null
  [[ $stderr_fd  -ge 0 ]] && { exec 2>&$stderr_fd {stderr_fd}>&- }
  [[ $lock_fd    -ge 0 ]] && zsystem flock -u $lock_fd
  [[ $req_fd     -ge 0 ]] && exec {req_fd}>&-
  [[ $resp_fd    -ge 0 ]] && { zle -F $resp_fd; exec {resp_fd}>&- }

  command rm -f $lock_file $req_fifo $resp_fifo

  unset -f gitstatus_start_impl

  >&2 print -P '[%F{red}ERROR%f]: gitstatus failed to initialize.'
  >&2 echo -E ''
  >&2 echo -E '  Your git prompt may disappear or become slow.'
  if [[ -s $xtrace_file ]]; then
    >&2 echo -E ''
    >&2 echo -E "  The content of ${(q-)xtrace_file} (gitstatus_start_impl xtrace):"
    >&2 print -P '%F{yellow}'
    >&2 awk '{print "    " $0}' <$xtrace_file
    >&2 print -P '%F{red}                               ^ this command failed%f'
  fi
  if [[ -s $log_file ]]; then
    >&2 echo -E ''
    >&2 echo -E "  The content of ${(q-)log_file} (gitstatus daemon log):"
    >&2 print -P '%F{yellow}'
    >&2 awk '{print "    " $0}' <$log_file
    >&2 print -nP '%f'
  fi
  if [[ ${GITSTATUS_ENABLE_LOGGING:-0} == 1 ]]; then
    >&2 echo -E ''
    >&2 echo -E '  Your system information:'
    >&2 print -P '%F{yellow}'
    >&2 echo -E "    zsh:      $ZSH_VERSION"
    >&2 echo -E "    uname -a: $(uname -a)"
    >&2 print -P '%f'
    >&2 echo -E '  If you need help, open an issue and attach this whole error message to it:'
    >&2 echo -E ''
    >&2 print -P '    %F{green}https://github.com/romkatv/gitstatus/issues/new%f'
  else
    >&2 echo -E ''
    >&2 echo -E '  Run the following command to retry with extra diagnostics:'
    >&2 print -P '%F{green}'
    >&2 echo -E "    GITSTATUS_ENABLE_LOGGING=1 gitstatus_start ${(@q-)*}"
    >&2 print -nP '%f'
  fi

  return 1

fi
