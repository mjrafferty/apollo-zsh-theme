# vim:ft=zsh

typeset -g __APOLLO_INSTALL_DIR="${(%):-%N}"
__APOLLO_INSTALL_DIR="${__APOLLO_INSTALL_DIR%/*}"

{

  for dir in functions modules; do
    if [[ ! -s "${__APOLLO_INSTALL_DIR}/${dir}.zwc" \
      || "${__APOLLO_INSTALL_DIR}/${dir}" -nt "${__APOLLO_INSTALL_DIR}/${dir}.zwc" ]]; then
          zcompile "${__APOLLO_INSTALL_DIR}/${dir}.tmp.zwc" "${__APOLLO_INSTALL_DIR}/${dir}/"*
          mv -f "${__APOLLO_INSTALL_DIR}/${dir}.tmp.zwc" "${__APOLLO_INSTALL_DIR}/${dir}.zwc"
    fi
  done

} &!

if [[ ${fpath[(ie)"${__APOLLO_INSTALL_DIR}/functions"]} -gt ${#fpath} ]]; then
  fpath+=("${__APOLLO_INSTALL_DIR}/functions.zwc" "${__APOLLO_INSTALL_DIR}/functions")
fi

autoload -Uz prompt_apollo_setup
prompt_apollo_setup
