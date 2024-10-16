#!/bin/bash

CONFIGS_BASE_URL='https://raw.githubusercontent.com/akiraohgaki/configs/main'

#CONFIG_DIR=''
FONTS_DIR=''
if [ "$(echo ${OSTYPE} | grep 'linux')" ]; then
  #CONFIG_DIR="${HOME}/.config"
  FONTS_DIR="${HOME}/.fonts"
elif [ "$(echo ${OSTYPE} | grep 'darwin')" ]; then
  #CONFIG_DIR="${HOME}/Library/Application Support"
  FONTS_DIR="${HOME}/Library/Fonts"
fi

install_file() {
  src_url="${1}"
  dest_path="${2}"
  file_mode=${3:-644}

  parent_dir="$(dirname "${dest_path}")"
  if [ ! -d "${parent_dir}" ]; then
    mkdir -p "${parent_dir}"
  fi

  curl -fsSL -o "${dest_path}" "${src_url}"
  chmod ${file_mode} "${dest_path}"

  echo "Installed: ${dest_path}"
}

uninstall_file() {
  dest_path="${1}"

  if [ -f "${dest_path}" ]; then
    rm "${dest_path}"

    echo "Uninstalled: ${dest_path}"
  fi
}

echo ''
echo '================================================'
echo 'Do you want to generate new SSH key ?'
echo "${HOME}/.ssh/id_ed25519"
echo "${HOME}/.ssh/id_ed25519.pub"
echo "${HOME}/.ssh/id_rsa"
echo "${HOME}/.ssh/id_rsa.pub"
echo '================================================'
read -p '[y/n]: ' input_val

if [ "${input_val}" = 'y' ]; then
  ssh-keygen -t ed25519 -N '' -f "${HOME}/.ssh/id_ed25519"
  ssh-keygen -t rsa -N '' -f "${HOME}/.ssh/id_rsa"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for SSH ?'
echo "${HOME}/.ssh/config"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/ssh/config" "${HOME}/.ssh/config"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.ssh/config"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for ZSH ?'
echo "${HOME}/.zshrc"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/zsh/.zshrc" "${HOME}/.zshrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.zshrc"
  uninstall_file "${HOME}/.zcompdump"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for Git ?'
echo "${HOME}/.gitconfig"
echo "${HOME}/.gitignore"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/git/.gitconfig" "${HOME}/.gitconfig"
  install_file "${CONFIGS_BASE_URL}/git/.gitignore" "${HOME}/.gitignore"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.gitconfig"
  uninstall_file "${HOME}/.gitignore"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for Vim ?'
echo "${HOME}/.vimrc"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/vim/.vimrc" "${HOME}/.vimrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.vimrc"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for EditorConfig ?'
echo "${HOME}/.editorconfig"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/editorconfig/.editorconfig" "${HOME}/.editorconfig"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.editorconfig"
fi

echo ''
echo '================================================'
echo 'Do you want to install additional fonts ?'
echo "${FONTS_DIR}/Cousine-Bold.ttf"
echo "${FONTS_DIR}/Cousine-BoldItalic.ttf"
echo "${FONTS_DIR}/Cousine-Regular.ttf"
echo "${FONTS_DIR}/Cousine-Italic.ttf"
echo "${FONTS_DIR}/UbuntuMono-B.ttf"
echo "${FONTS_DIR}/UbuntuMono-BI.ttf"
echo "${FONTS_DIR}/UbuntuMono-R.ttf"
echo "${FONTS_DIR}/UbuntuMono-RI.ttf"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CONFIGS_BASE_URL}/fonts/Cousine-Bold.ttf" "${FONTS_DIR}/Cousine-Bold.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/Cousine-BoldItalic.ttf" "${FONTS_DIR}/Cousine-BoldItalic.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/Cousine-Regular.ttf" "${FONTS_DIR}/Cousine-Regular.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/Cousine-Italic.ttf" "${FONTS_DIR}/Cousine-Italic.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/UbuntuMono-B.ttf" "${FONTS_DIR}/UbuntuMono-B.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/UbuntuMono-BI.ttf" "${FONTS_DIR}/UbuntuMono-BI.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/UbuntuMono-R.ttf" "${FONTS_DIR}/UbuntuMono-R.ttf"
  install_file "${CONFIGS_BASE_URL}/fonts/UbuntuMono-RI.ttf" "${FONTS_DIR}/UbuntuMono-RI.ttf"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${FONTS_DIR}/Cousine-Bold.ttf"
  uninstall_file "${FONTS_DIR}/Cousine-BoldItalic.ttf"
  uninstall_file "${FONTS_DIR}/Cousine-Regular.ttf"
  uninstall_file "${FONTS_DIR}/Cousine-Italic.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-B.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-BI.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-R.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-RI.ttf"
fi
