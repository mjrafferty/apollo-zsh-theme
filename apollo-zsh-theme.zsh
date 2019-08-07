# vim:ft=zsh

typeset -g __APOLLO_INSTALL_DIR="${(%):-%N}"
__APOLLO_INSTALL_DIR="${__APOLLO_INSTALL_DIR%/*}"

fpath+=("${__APOLLO_INSTALL_DIR}/functions")

autoload -Uz prompt_apollo_setup
prompt_apollo_setup
