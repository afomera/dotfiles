" github-dark.vim — minimal GitHub Dark Default colorscheme
" No plugins required. Just drop in colors/ and set colorscheme.

highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "github-dark"

set background=dark

" UI
hi Normal       guifg=#e6edf3 guibg=#0d1117 ctermfg=253 ctermbg=233
hi CursorLine   guibg=#161b22 ctermbg=234 cterm=NONE
hi LineNr       guifg=#484f58 ctermfg=240
hi CursorLineNr guifg=#e6edf3 ctermfg=253
hi Visual       guibg=#264f78 ctermbg=24
hi StatusLine   guifg=#e6edf3 guibg=#161b22 ctermfg=253 ctermbg=234
hi StatusLineNC guifg=#484f58 guibg=#0d1117 ctermfg=240 ctermbg=233
hi VertSplit    guifg=#21262d ctermfg=236
hi Pmenu        guifg=#e6edf3 guibg=#161b22 ctermfg=253 ctermbg=234
hi PmenuSel     guifg=#e6edf3 guibg=#264f78 ctermfg=253 ctermbg=24
hi Search       guifg=#0d1117 guibg=#e3b341 ctermfg=233 ctermbg=220
hi MatchParen   guibg=#30363d ctermbg=237

" Syntax
hi Comment      guifg=#8b949e ctermfg=245 gui=italic cterm=italic
hi Constant     guifg=#79c0ff ctermfg=117
hi String       guifg=#a5d6ff ctermfg=153
hi Character    guifg=#a5d6ff ctermfg=153
hi Number       guifg=#79c0ff ctermfg=117
hi Boolean      guifg=#79c0ff ctermfg=117
hi Float        guifg=#79c0ff ctermfg=117
hi Identifier   guifg=#ffa657 ctermfg=215
hi Function     guifg=#d2a8ff ctermfg=183
hi Statement    guifg=#ff7b72 ctermfg=203
hi Keyword      guifg=#ff7b72 ctermfg=203
hi Conditional  guifg=#ff7b72 ctermfg=203
hi Repeat       guifg=#ff7b72 ctermfg=203
hi Operator     guifg=#ff7b72 ctermfg=203
hi PreProc      guifg=#ff7b72 ctermfg=203
hi Include      guifg=#ff7b72 ctermfg=203
hi Type         guifg=#ffa657 ctermfg=215
hi StorageClass guifg=#ff7b72 ctermfg=203
hi Structure    guifg=#ffa657 ctermfg=215
hi Special      guifg=#79c0ff ctermfg=117
hi Delimiter    guifg=#e6edf3 ctermfg=253
hi Error        guifg=#f85149 guibg=NONE ctermfg=196
hi Todo         guifg=#d2a8ff guibg=NONE ctermfg=183 gui=bold cterm=bold

" Diff
hi DiffAdd      guibg=#12261e ctermbg=22
hi DiffChange   guibg=#272115 ctermbg=58
hi DiffDelete   guifg=#f85149 guibg=#2d1215 ctermfg=196 ctermbg=52
hi DiffText     guibg=#3b2e04 ctermbg=94
