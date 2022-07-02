if [ -d "${HOME}/bin" ]; then
  export PATH="${HOME}/bin:${PATH}"
fi

if [ -d "${HOME}/.local/bin" ]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi

export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
export LSCOLORS='gxfxcxdxbxegedabagacag'

autoload -Uz compinit && compinit
autoload -Uz colors && colors

setopt correct
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

PROMPT="%{${fg[green]}%}%n %{${fg[yellow]}%}%~
%{${fg[red]}%}%# %{${reset_color}%}"
PROMPT2="%{${fg[yellow]}%} %_ > %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

if [ "$(echo ${OSTYPE} | grep 'linux')" ]; then
  alias ls='ls -F --color'
elif [ "$(echo ${OSTYPE} | grep 'darwin')" ]; then
  alias ls='ls -F -G'
fi
