# vim:ft=zsh

# Manual install:
# fpath+=( $HOME/apollo-zsh-theme/functions $HOME/apollo-zsh-theme/modules )
# autoload -Uz promptinit && promptinit
# source apollo-zsh-theme/conf/theme.conf
# prompt apollo

typeset -g __APOLLO_INSTALL_DIR="${(%):-%N}"
__APOLLO_INSTALL_DIR="${__APOLLO_INSTALL_DIR%/*}"

{

  for dir in functions modules; do
    [[ ! -s "${__APOLLO_INSTALL_DIR}/${dir}.zwc" \
      || "${__APOLLO_INSTALL_DIR}/${dir}" -nt "${__APOLLO_INSTALL_DIR}/${dir}.zwc" ]] \
      && zcompile "${__APOLLO_INSTALL_DIR}/${dir}.zwc" "${__APOLLO_INSTALL_DIR}/${dir}/"*
  done

} &!

if [[ ${fpath[(ie)"${__APOLLO_INSTALL_DIR}/functions"]} -gt ${#fpath} ]]; then
  fpath+=("${__APOLLO_INSTALL_DIR}/functions.zwc" "${__APOLLO_INSTALL_DIR}/functions")
fi

autoload -Uz prompt_apollo_setup
prompt_apollo_setup
