set nocompatible

let mapleader = " "

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax enable
colorscheme monokai

" Folding
set foldlevel=1
set foldmethod=syntax

" use the system clipboard
set clipboard+=unnamedplus

" Tab mappings
map <Leader>tt :tabnew<cr>
map <Leader>tn :tabnext<cr>
map <Leader>tp :tabprevious<cr>

" Test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>
tmap <C-o> <C-\><C-n>
let test#strategy = "neovim"

" NERDTree keybindings
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" For Telescope keybindings (fuzzysearch)
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

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
