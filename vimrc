syntax enable
colorscheme monokai

" Turn mouse on
set mouse=a

set textwidth=110	" set to rubocop length

set autoread            " automatically reload if file changes outside of vim
set ruler		" show the cursor position all the time
set number		" show line numbers
set numberwidth=3	" width of the number gutter

set hls			" highlight search results
set splitbelow 		" open horizontal splits below
set splitright		" open vertical splits to the right
set nobackup
set nowritebackup
set noswapfile

set autoindent		" always have automatic indenting on
set shiftwidth=2
set smarttab
set expandtab		" spaces instead of tabs
set scrolloff=3         " start scrolling 5 lines before edge of viewport

" Change the color of the editor after 120 chars, except for the quickfix panel.
let &colorcolumn=join(range(121,999),",")
au FileType qf setlocal nonumber colorcolumn=
