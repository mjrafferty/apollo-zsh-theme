# vim:ft=bash

typeset -g _APOLLO_BYTE_SUFFIX
_APOLLO_BYTE_SUFFIX=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')

# If we execute `print -P $1`, how many characters will be printed on the last line?
_apollo_prompt_length() {

  emulate -L zsh

  local -i x y m
  y=$#1

  if (( y )); then

    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ));
    done

    while (( y > x + 1 )); do
      m=$(( x + (y - x) / 2 ))
      typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
    done

  fi

  _APOLLO_RETURN_MESSAGE=$x
}

_apollo_human_readable_bytes() {

  local suf
  typeset -F 2 n
  n=$1

  for suf in $_APOLLO_BYTE_SUFFIX; do
    (( n < 100 )) && break
    (( n /= 1024 ))
  done

  _APOLLO_RETURN_MESSAGE=$n$suf

}

_apollo_parse_ip() {

  local desiredInterface rawInterfaces pattern relevantInterfaces newline interfaceName interface ipFound
  local -a interfaces relevantInterfaces interfaceStates

  desiredInterface=${1:-'^[^ ]+'}

  if [[ $OS == OSX ]]; then

    if [[ ! -x /sbin/ifconfig ]]; then
      return
    fi

    rawInterfaces="$(/sbin/ifconfig -l 2>/dev/null)";

    if [[ -z $rawInterfaces ]]; then
      return
    fi

    interfaces=(${(A)=rawInterfaces})
    pattern="${desiredInterface}[^ ]?"

    for rawInterface in $interfaces; do
      if [[ "$rawInterface" =~ $pattern ]]; then
        relevantInterfaces+=$MATCH
      fi
    done

    newline=$'\n'

    echo "${relevantInterfaces[*]}"
    for interfaceName in $relevantInterfaces; do

      interface="$(/sbin/ifconfig $interfaceName 2>/dev/null)" || continue

      if [[ "${interface}" =~ "lo[0-9]*" ]]; then
        continue
      fi

      if [[ "${interface//${newline}/}" =~ "<([^>]*)>(.*)inet[ ]+([^ ]*)" ]]; then

        ipFound="${match[3]}"
        interfaceStates=(${(s:,:)match[1]})

        if (( ${interfaceStates[(I)UP]} )); then
          _APOLLO_RETURN_MESSAGE=$ipFound
          return
        fi

      fi
    done
  else

    if [[ ! -x /sbin/ip ]]; then
      return
    fi

    interfaces=( "${(f)$(/sbin/ip -brief -4 a show 2>/dev/null)}" )
    pattern="^${desiredInterface}[[:space:]]+UP[[:space:]]+([^/ ]+)"

    for interface in "${(@)interfaces}"; do
      if [[ "$interface" =~ $pattern ]]; then
        _APOLLO_RETURN_MESSAGE=$match[1]
        return
      fi
    done

  fi

  return 1

}

_apollo_read_file() {

  _APOLLO_RETURN_MESSAGE=''

  if [[ -n $1 ]]; then
    read -r _APOLLO_RETURN_MESSAGE <$1
  fi

  [[ -n $_APOLLO_RETURN_MESSAGE ]]

}

_apollo_escape_rcurly() {
  _APOLLO_RETURN_MESSAGE=${${1//\\/\\\\}//\}/\\\}}
}

# Returns 1 if the cursor is at the very end of the screen.
_apollo_left_prompt_end_line() {

  _apollo_get_icon LEFT_SEGMENT_SEPARATOR
  _apollo_escape_rcurly $_APOLLO_RETURN_MESSAGE

  _APOLLO_PROMPT+="%k%b"
  _APOLLO_PROMPT+="\${_APOLLO_N::=}"
  _APOLLO_PROMPT+="\${\${\${_APOLLO_BG:#NONE}:-\${_APOLLO_N:=1}}+}"
  _APOLLO_PROMPT+="\${\${_APOLLO_N:=2}+}"
  _APOLLO_PROMPT+="\${\${_APOLLO_T[2]::=%F{\$_APOLLO_BG\}$_APOLLO_RETURN_MESSAGE}+}"
  _APOLLO_PROMPT+="\${_APOLLO_T[\$_APOLLO_N]}"
  _APOLLO_PROMPT+="%f$1%f%k%b"

  if (( ! _APOLLO_RPROMPT_DONE )); then
    _APOLLO_PROMPT+=$_APOLLO_ALIGNED_RPROMPT
    _APOLLO_RPROMPT_DONE=1
    return 1
  fi
}

_apollo_zle_keymap_select() {
  zle && zle .reset-prompt && zle -R
}
