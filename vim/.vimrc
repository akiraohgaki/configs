" vim-plug
function InitPlug() abort
  call plug#begin('~/.vim/plugged')
  Plug 'editorconfig/editorconfig-vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'
  call plug#end()
endfunction

if filereadable($HOME . '/.vim/autoload/plug.vim')
  call InitPlug()
else
  call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  echo 'vim-plug installed'
  call InitPlug()
  echo 'Please do :PlugInstall to install plugins'
endif

" Files
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden

" Editor
syntax enable
set visualbell
set number
set cursorline
set virtualedit=onemore
set whichwrap=b,s,[,],<,>
set smartindent
set showmatch
set expandtab
set tabstop=2
set shiftwidth=2

" Status
set title
set laststatus=2
set ruler
set wildmenu
set showcmd

" Search
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
