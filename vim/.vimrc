" vim-plug
function InitPlug() abort
  call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  "Plug 'tpope/vim-fugitiv'
  Plug 'airblade/vim-gitgutter'
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

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'simple'
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab
