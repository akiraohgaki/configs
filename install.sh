#!/bin/bash

CONFIGS_BASE_URL='https://raw.githubusercontent.com/akiraohgaki/configs/main'

PREFIX='/usr/local'

TEMPLATES_DIR="${HOME}/Templates"

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

sudo_resolve_parent_dir() {
  dest_path="${1}"

  parent_dir="$(dirname "${dest_path}")"

  if [ ! -d "${parent_dir}" ]; then
    sudo mkdir -p "${parent_dir}"
  fi
}

install_file_url() {
  src_url="${1}"
  dest_path="${2}"
  file_mode=${3:-644}

  resolve_parent_dir "${dest_path}"
  curl -fsSL "${src_url}" -o "${dest_path}"
  chmod ${file_mode} "${dest_path}"

  echo "Installed: ${dest_path}"
}

sudo_install_file_url() {
  src_url="${1}"
  dest_path="${2}"
  file_mode=${3:-644}

  sudo_resolve_parent_dir "${dest_path}"
  sudo curl -fsSL "${src_url}" -o "${dest_path}"
  sudo chmod ${file_mode} "${dest_path}"

  echo "Installed: ${dest_path}"
}

uninstall_file() {
  dest_path="${1}"

  if [ -f "${dest_path}" ]; then
    rm "${dest_path}"

    echo "Uninstalled: ${dest_path}"
  fi
}

sudo_uninstall_file() {
  dest_path="${1}"

  if [ -f "${dest_path}" ]; then
    sudo rm "${dest_path}"

    echo "Uninstalled: ${dest_path}"
  fi
}

echo ''
echo '================================================'
echo 'Do you want to install Deno ?'
echo "(will be installed in ${PREFIX})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL="${PREFIX}" sh
elif [ "${input_val}" = 'uninstall' ]; then
  sudo_uninstall_file "${PREFIX}/bin/deno"
fi

echo ''
echo '================================================'
echo 'Do you want to install Node.js with n ?'
echo "(will be installed in ${PREFIX})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  sudo_install_file_url https://raw.githubusercontent.com/tj/n/master/bin/n "${PREFIX}/bin/n" 755
  sudo n lts
elif [ "${input_val}" = 'uninstall' ]; then
  sudo n uninstall
  sudo rm -rf /usr/local/n
  sudo_uninstall_file "${PREFIX}/bin/n"
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
      jest jest-junit jest-mock \
      -g
    sudo chown -R $(id -un):$(id -gn) "${HOME}/.npm"
    sudo chown -R $(id -un):$(id -gn) "${HOME}/.config"
  elif [ "${input_val}" = 'uninstall' ]; then
    sudo npm uninstall \
      yarn \
      typescript @types/node \
      nodemon \
      prettier \
      eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin \
      react react-dom @types/react @types/react-dom eslint-plugin-react eslint-plugin-react-hooks \
      jest jest-junit jest-mock \
      -g
  fi
fi

echo ''
echo '================================================'
echo 'Do you want to generate new SSH key ?'
echo "(will be installed in ${HOME}/.ssh)"
echo '================================================'
read -p '[y/n]: ' input_val

if [ "${input_val}" = 'y' ]; then
  ssh-keygen -t ed25519 -N '' -f "${HOME}/.ssh/id_ed25519"
  ssh-keygen -t rsa -N '' -f "${HOME}/.ssh/id_rsa"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for SSH ?'
echo "(will be installed in ${HOME}/.ssh)"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/ssh/config" "${HOME}/.ssh/config"
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
  install_file_url "${CONFIGS_BASE_URL}/zsh/.zshrc" "${HOME}/.zshrc"
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
  install_file_url "${CONFIGS_BASE_URL}/git/.gitconfig" "${HOME}/.gitconfig"
  install_file_url "${CONFIGS_BASE_URL}/git/.gitignore" "${HOME}/.gitignore"

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
  install_file_url "${CONFIGS_BASE_URL}/vim/.vimrc" "${HOME}/.vimrc"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.vimrc"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for EditorConfig ?'
echo "(will be installed in ${HOME})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/editorconfig/.editorconfig" "${HOME}/.editorconfig"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${HOME}/.editorconfig"
fi

echo ''
echo '================================================'
echo 'Do you want to install additional fonts ?'
echo "(will be installed in ${FONTS_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/fonts/Cousine-Bold.ttf" "${FONTS_DIR}/Cousine-Bold.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/Cousine-BoldItalic.ttf" "${FONTS_DIR}/Cousine-BoldItalic.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/Cousine-Regular.ttf" "${FONTS_DIR}/Cousine-Regular.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/Cousine-Italic.ttf" "${FONTS_DIR}/Cousine-Italic.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/UbuntuMono-B.ttf" "${FONTS_DIR}/UbuntuMono-B.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/UbuntuMono-BI.ttf" "${FONTS_DIR}/UbuntuMono-BI.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/UbuntuMono-R.ttf" "${FONTS_DIR}/UbuntuMono-R.ttf"
  install_file_url "${CONFIGS_BASE_URL}/fonts/UbuntuMono-RI.ttf" "${FONTS_DIR}/UbuntuMono-RI.ttf"
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
echo 'Do you want to install config file for Prettier ?'
echo "(will be installed in ${TEMPLATES_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/prettier/.prettierrc.json" "${TEMPLATES_DIR}/.prettierrc.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${TEMPLATES_DIR}/.prettierrc.json"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for ESLint ?'
echo "(will be installed in ${TEMPLATES_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/eslint/.eslintrc.json" "${TEMPLATES_DIR}/.eslintrc.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${TEMPLATES_DIR}/.eslintrc.json"
fi

echo ''
echo '================================================'
echo 'Do you want to install config file for TypeScript ?'
echo "(will be installed in ${TEMPLATES_DIR})"
echo '================================================'
read -p '[y/n/uninstall]: ' input_val

if [ "${input_val}" = 'y' ]; then
  install_file_url "${CONFIGS_BASE_URL}/typescript/tsconfig.json" "${TEMPLATES_DIR}/tsconfig.json"
elif [ "${input_val}" = 'uninstall' ]; then
  uninstall_file "${TEMPLATES_DIR}/tsconfig.json"
fi
