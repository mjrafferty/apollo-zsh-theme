# vim:ft=zsh

typeset -g __APOLLO_INSTALL_DIR="${(%):-%N}"
__APOLLO_INSTALL_DIR="${__APOLLO_INSTALL_DIR%/*}"

#[[ ! -e "${__APOLLO_INSTALL_DIR}/functions.zwc" ]] \
  #&& zcompile "${__APOLLO_INSTALL_DIR}/functions.zwc" "${__APOLLO_INSTALL_DIR}/functions/"*

#[[ ! -e "${__APOLLO_INSTALL_DIR}/modules.zwc" ]] \
  #&& zcompile "${__APOLLO_INSTALL_DIR}/modules.zwc" "${__APOLLO_INSTALL_DIR}/modules/"*

fpath+=("${__APOLLO_INSTALL_DIR}/functions")

autoload -Uz prompt_apollo_setup
prompt_apollo_setup
