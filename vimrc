set nocompatible

let mapleader = " "

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }

" turn off -- INSERT mode -- etc text since we're using lightline
set noshowmode

syntax enable
colorscheme monokai

" Folding
" set foldlevel=1
" set foldmethod=syntax

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
nnoremap <leader>fk <cmd>Telescope grep_string<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>

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

" Search settings
set hls			" highlight search results
set incsearch           " incremental search, search as characters are typed

" turn off search highlighting with <CR> (carriage-return)
nnoremap <CR> :nohlsearch<CR><CR>

set splitbelow 		" open horizontal splits below
set splitright		" open vertical splits to the right
set nobackup
set nowritebackup
set noswapfile

set autoindent		" always have automatic indenting on
set shiftwidth=2
set smarttab
set expandtab		" spaces instead of tabs
set scrolloff=5         " start scrolling 5 lines before edge of viewport

set cmdheight=2	" set the height of the command line

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Change the color of the editor after 120 chars, except for the quickfix panel.
let &colorcolumn=join(range(121,999),",")
au FileType qf setlocal nonumber colorcolumn=

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup MISC
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END
