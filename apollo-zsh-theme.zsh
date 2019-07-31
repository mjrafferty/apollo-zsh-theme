# vim:ft=zsh

typeset -g _APOLLO_INSTALL_DIR="${(%):-%N}"
_APOLLO_INSTALL_DIR="${_APOLLO_INSTALL_DIR%/*}"

fpath+=("${_APOLLO_INSTALL_DIR}/functions")

autoload -Uz promptinit && promptinit

prompt apollo
