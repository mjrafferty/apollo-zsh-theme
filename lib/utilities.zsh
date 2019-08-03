# vim:ft=zsh

typeset -g _APOLLO_BYTE_SUFFIX
_APOLLO_BYTE_SUFFIX=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')

_apollo_get_display_width(){

  local format_regex='%([BSUbfksu]|([FK]|){*})'

  _APOLLO_RETURN_MESSAGE="${(m)#${(S%%)1//$~format_regex/}}"

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
