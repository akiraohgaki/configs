" vim-plug
function InitPlug() abort
  call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive'
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
  call system('curl -fsSL -o ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  echo 'vim-plug installed'
  call InitPlug()
  echo 'Please do :PlugInstall to install plugins'
endif

" vim-airline
let g:airline_theme = 'simple'
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" Files
set encoding=utf-8
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
