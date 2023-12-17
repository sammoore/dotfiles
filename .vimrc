"
" Vundle + plugins
"
set nocompatible
filetype off
let g:polyglot_disabled = ['kotlin'] " we use a custom vim-kotlin

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'wincent/command-t'
Plugin 'preservim/nerdtree'
Plugin 'elzr/vim-json'
Plugin 'yuezk/vim-js'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'samtheprogram/kotlin-vim'
Plugin 'neoclide/coc.nvim'
call vundle#end()

filetype plugin indent on
syntax on

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:vim_json_syntax_conceal = 0


"
" General
"
set backspace=indent,eol,start
set re=0

set showtabline=2

set number
set noruler " splits (+ coc?) breaks ruler
set statusline+=\ %l\,%c " custom ruler
set statusline+=\ %f " add filename
set laststatus=2 " always show statusline
set colorcolumn=101

fun! WordWrap()
  set nolist " just in case it's been switched on to see tabs + newlines
  set linebreak
  set wrap
  set textwidth?
endfun

set tabstop=8
set shiftwidth=2
set softtabstop=-1 " insert mode only: treat shiftwidth # of spaces as a tab
set expandtab

fun! HardTabs()
  set noexpandtab
  set shiftwidth=8
  set softtabstop=0
endfun

map \R :source $HOME/.vimrc<CR>
nn \d :nohlsearch<CR>
nn \2 :setlocal shiftwidth=2<CR>
nn \4 :setlocal shiftwidth=4<CR>
nn \<TAB> :set shiftwidth=8 softtabstop=0 noexpandtab<CR>
nn \<S-TAB> :set shiftwidth=2 softtabstop=-1 expandtab<CR>
nn \\<TAB> :set foldmethod=indent<CR>

nn \a :! git add %<CR>
nn \B :! git blame %<CR>
nn \Dd :! git diff %<CR>
nn \DD :! git diff<CR>
nn \c :! git rebase --continue<CR>
nn \C :! git commit<CR>
nn \s :! git status<CR>
nn \U :! git add -u<CR>
nn \< /<<<<<<CR>

"
" Kotlin
"
autocmd BufReadPost *.kt setlocal filetype=kotlin
autocmd FileType kotlin setlocal shiftwidth=4
autocmd FileType kotlin setlocal cinoptions=+8 " intellij-style continuation indent
autocmd BufReadPost *ServerApplication.kt setlocal paste
autocmd BufReadPost application.properties setlocal noeol
autocmd BufReadPost application.properties setlocal nofixendofline


"
" NERDTree
"
map <C-n> :NERDTreeToggle<CR>


"
" command-t
"
set wildignore+=*/node_modules
set wildignore+=*/build
set wildignore+=*/dist

" typescript-specific wildignore stuff
let s:MY_typescriptArtifactExtensions = ['*.d.ts', '*.map', '*.js']

fun! ToggleIgnoreTypescriptArtifacts()
  for ext in s:MY_typescriptArtifactExtensions
    if &wildignore =~ ext
      execute 'set wildignore-='.ext
    else
      execute 'set wildignore+='.ext
    endif
  endfor
endfun

if filereadable(expand("tsconfig.json"))
  call ToggleIgnoreTypescriptArtifacts()
endif

" TODO: seems like command-t doesn't support wildignore changes after startup
nmap \j :call ToggleIgnoreTypescriptArtifacts()<CR>

let g:CommandTTraverseSCM="pwd"

"
" coc
"

" TextEdit might fail if hidden is not set
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=4

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience
set updatetime=1000

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostic appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <cr> to confirm completion
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" NOTE: [...] this coc config is abridged here

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" NOTE: [...] this coc config is abridged here

