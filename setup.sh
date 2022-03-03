#!/bin/bash

CURDIR="$(cd "$(dirname "${0}")" && pwd)"

PREFIX='/usr/local'

PROJECTS_DIR="${HOME}/Projects"

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

echo ''
echo '================================================'
echo 'Do you want to generate new SSH key ?'
echo "(will be installed in ${HOME}/.ssh)"
echo '================================================'
read -p '[y/n]: ' input_val

if [ "${input_val}" = 'y' ]; then
  ssh-keygen -t ed25519 -N '' -f "${CURDIR}/ssh/id_ed25519"
  ssh-keygen -t rsa -N '' -f "${CURDIR}/ssh/id_rsa"
  install_file "${CURDIR}/ssh/id_ed25519" "${HOME}/.ssh/id_ed25519" 600
  install_file "${CURDIR}/ssh/id_ed25519.pub" "${HOME}/.ssh/id_ed25519.pub"
  install_file "${CURDIR}/ssh/id_rsa" "${HOME}/.ssh/id_rsa" 600
  install_file "${CURDIR}/ssh/id_rsa.pub" "${HOME}/.ssh/id_rsa.pub"
  chmod 700 "${HOME}/.ssh"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for SSH ?'
echo "(will be installed in ${HOME}/.ssh)"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/ssh/config" "${HOME}/.ssh/config"
  chmod 700 "${HOME}/.ssh"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.ssh/config"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for ZSH ?'
echo "(will be installed in ${HOME})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/zsh/.zshrc" "${HOME}/.zshrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.zshrc"
  uninstall_file "${HOME}/.zcompdump"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for Git ?'
echo "(will be installed in ${HOME})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/git/.gitconfig" "${HOME}/.gitconfig"
  install_file "${CURDIR}/git/.gitignore" "${HOME}/.gitignore"

  echo ''
  echo '================================================'
  echo 'Enter your name and email for Git commits'
  echo '================================================'
  read -p 'Your Name: ' input_val
  git config --global user.name "${input_val}"
  read -p 'Your Email: ' input_val
  git config --global user.email "${input_val}"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.gitconfig"
  uninstall_file "${HOME}/.gitignore"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for Vim ?'
echo "(will be installed in ${HOME})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/vim/.vimrc" "${HOME}/.vimrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.vimrc"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for EditorConfig ?'
echo "(will be installed in ${PROJECTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/editorconfig/.editorconfig" "${PROJECTS_DIR}/.editorconfig"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${PROJECTS_DIR}/.editorconfig"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for Prettier ?'
echo "(will be installed in ${PROJECTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/prettier/.prettierrc.json" "${PROJECTS_DIR}/.prettierrc.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${PROJECTS_DIR}/.prettierrc.json"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for ESLint ?'
echo "(will be installed in ${PROJECTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/eslint/.eslintrc.json" "${PROJECTS_DIR}/.eslintrc.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${PROJECTS_DIR}/.eslintrc.json"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for TypeScript ?'
echo "(will be installed in ${PROJECTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/typescript/tsconfig.json" "${PROJECTS_DIR}/tsconfig.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${PROJECTS_DIR}/tsconfig.json"
fi

echo ''
echo '================================================'
echo 'Do you want to install additional fonts ?'
echo "(will be installed in ${FONTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file "${CURDIR}/fonts/Cousine-Bold.ttf" "${FONTS_DIR}/Cousine-Bold.ttf"
  install_file "${CURDIR}/fonts/Cousine-BoldItalic.ttf" "${FONTS_DIR}/Cousine-BoldItalic.ttf"
  install_file "${CURDIR}/fonts/Cousine-Regular.ttf" "${FONTS_DIR}/Cousine-Regular.ttf"
  install_file "${CURDIR}/fonts/Cousine-Italic.ttf" "${FONTS_DIR}/Cousine-Italic.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-B.ttf" "${FONTS_DIR}/UbuntuMono-B.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-BI.ttf" "${FONTS_DIR}/UbuntuMono-BI.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-R.ttf" "${FONTS_DIR}/UbuntuMono-R.ttf"
  install_file "${CURDIR}/fonts/UbuntuMono-RI.ttf" "${FONTS_DIR}/UbuntuMono-RI.ttf"
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

echo ''
echo '================================================'
echo 'Do you want to install Node.js with n ?'
echo "(will be installed in ${PREFIX}/bin)"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  sudo bash "${0}" install_nodejs
elif [ "${input_val}" = 'uninstall' ]; then
  sudo bash "${0}" uninstall_nodejs
fi

if [ "$(which npm)" ]; then
  echo ''
  echo '================================================'
  echo 'Do you want to install additional NPM packages ?'
  echo "(will be installed in $(npm root -g))"
  echo '================================================'
  read -p '[y/n/uninstall]: ' input_val

  if [ "${input_val}" = 'y' ]; then
    sudo npm install \
      yarn \
      typescript @types/node \
      nodemon \
      prettier \
      eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin \
      react react-dom @types/react @types/react-dom eslint-plugin-react eslint-plugin-react-hooks \
      jest jest-junit \
      -g
    sudo chown -R "${USER}" "${HOME}/.npm"
    sudo chown -R "${USER}" "${HOME}/.config"
  elif [ "${input_val}" = 'uninstall' ]; then
    sudo npm uninstall \
      yarn \
      typescript @types/node \
      nodemon \
      prettier \
      eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin \
      react react-dom @types/react @types/react-dom eslint-plugin-react eslint-plugin-react-hooks \
      jest jest-junit \
      -g
  fi
fi
