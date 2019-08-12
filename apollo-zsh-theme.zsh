# vim:ft=zsh

typeset -g __APOLLO_INSTALL_DIR="${(%):-%N}"
__APOLLO_INSTALL_DIR="${__APOLLO_INSTALL_DIR%/*}"

{

  for dir in functions modules conf; do
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
