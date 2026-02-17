set nocompatible
let mapleader = " "

syntax enable
set mouse=a
set clipboard+=unnamedplus
set number
set numberwidth=3
set ruler
set autoread

" Search
set hlsearch
set incsearch
nnoremap <CR> :nohlsearch<CR><CR>

" Splits
set splitbelow
set splitright
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Indentation
set autoindent
set shiftwidth=2
set smarttab
set expandtab
set scrolloff=5

" Misc
set nobackup
set nowritebackup
set noswapfile
set noerrorbells
set novisualbell
