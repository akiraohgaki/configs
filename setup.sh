#!/bin/bash

CURDIR="$(cd "$(dirname "${0}")" && pwd)"

PREFIX='/usr/local'

#CONFIG_DIR=''
FONTS_DIR=''
if [ "$(echo ${OSTYPE} | grep 'linux')" ]; then
  #CONFIG_DIR="${HOME}/.config"
  FONTS_DIR="${HOME}/.fonts"
elif [ "$(echo ${OSTYPE} | grep 'darwin')" ]; then
  #CONFIG_DIR="${HOME}/Library/Application Support"
  FONTS_DIR="${HOME}/Library/Fonts"
fi

resolve_parent_dir() {
  dest_path="${1}"

  parent_dir="$(dirname "${dest_path}")"

  if [ ! -d "${parent_dir}" ]; then
    mkdir -p "${parent_dir}"
  fi
}

install_file() {
  src_path="${1}"
  dest_path="${2}"
  file_mode=${3:-644}

  if [ -f "${src_path}" ]; then
    resolve_parent_dir "${dest_path}"
    install -m ${file_mode} "${src_path}" "${dest_path}"

    echo "Installed: ${dest_path}"
  fi
}

install_file_url() {
  src_url="${1}"
  dest_path="${2}"
  file_mode=${3:-644}

  resolve_parent_dir "${dest_path}"
  curl -L "${src_url}" -o "${dest_path}"
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

install_nodejs() {
  install_file_url https://raw.githubusercontent.com/tj/n/master/bin/n "${PREFIX}/bin/n" 755
  n lts
}

uninstall_nodejs() {
  n uninstall
  rm -rf /usr/local/n
  uninstall_file "${PREFIX}/bin/n"
}

if [ "${1}" ]; then
  "${1}"
  exit
fi

echo '================================================'
echo 'Do you want to generate new SSH key ?'
echo '================================================'
read -p '[y/n]: ' input_val

if [ "${input_val}" = 'y' ]; then
  ssh-keygen -t ed25519 -N '' -f "${CURDIR}/ssh/id_ed25519"
  ssh-keygen -t rsa -N '' -f "${CURDIR}/ssh/id_rsa"
fi

echo '================================================'
echo 'Do you want to install config file for SSH ?'
echo '(also install/uninstall generated SSH keys)'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/ssh/config" "${HOME}/.ssh/config"
  install_file "${CURDIR}/ssh/id_ed25519" "${HOME}/.ssh/id_ed25519" 600
  install_file "${CURDIR}/ssh/id_ed25519.pub" "${HOME}/.ssh/id_ed25519.pub"
  install_file "${CURDIR}/ssh/id_rsa" "${HOME}/.ssh/id_rsa" 600
  install_file "${CURDIR}/ssh/id_rsa.pub" "${HOME}/.ssh/id_rsa.pub"
  chmod 700 "${HOME}/.ssh"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.ssh/config"
  uninstall_file "${HOME}/.ssh/id_ed25519"
  uninstall_file "${HOME}/.ssh/id_ed25519.pub"
  uninstall_file "${HOME}/.ssh/id_rsa"
  uninstall_file "${HOME}/.ssh/id_rsa.pub"
fi

echo '================================================'
echo 'Do you want to install config file for ZSH ?'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/zsh/.zshrc" "${HOME}/.zshrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.zshrc"
  uninstall_file "${HOME}/.zcompdump"
fi

echo '================================================'
echo 'Do you want to install config file for Git ?'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/git/.gitconfig" "${HOME}/.gitconfig"
  install_file "${CURDIR}/git/.gitignore" "${HOME}/.gitignore"

  echo '================================================'
  echo 'Enter your information for commits'
  echo '================================================'
  read -p 'git config user.name: ' input_val
  git config --global user.name "${input_val}"
  read -p 'git config user.email: ' input_val
  git config --global user.email "${input_val}"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.gitconfig"
  uninstall_file "${HOME}/.gitignore"
fi

echo '================================================'
echo 'Do you want to install config file for EditorConfig ?'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/editorconfig/.editorconfig" "${HOME}/.editorconfig"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.editorconfig"
fi

echo '================================================'
echo 'Do you want to install UbuntuMono fonts ?'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/fonts/UbuntuMono-B.ttf" "${FONTS_DIR}/UbuntuMono-B.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-BI.ttf" "${FONTS_DIR}/UbuntuMono-BI.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-R.ttf" "${FONTS_DIR}/UbuntuMono-R.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-RI.ttf" "${FONTS_DIR}/UbuntuMono-RI.ttf"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${FONTS_DIR}/UbuntuMono-B.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-BI.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-R.ttf"
  uninstall_file "${FONTS_DIR}/UbuntuMono-RI.ttf"
fi

echo '================================================'
echo 'Do you want to install Node.js with n ?'
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  sudo bash "${0}" install_nodejs
elif [ "${input_val}" = 'uninstall' ]; then
  sudo bash "${0}" uninstall_nodejs
fi
