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
Plugin 'sheerun/vim-polyglot'
Plugin 'samtheprogram/kotlin-vim'
Plugin 'neoclide/coc.nvim'
call vundle#end()

filetype plugin indent on


"
" General
"
set showtabline=2

set number
set noruler " splits (+ coc?) breaks ruler
set statusline+=\ %l\,%c " custom ruler
set laststatus=2 " always show statusline
set colorcolumn=101

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


"
" Kotlin
"
autocmd BufReadPost *.kt setlocal filetype=kotlin
autocmd FileType kotlin setlocal shiftwidth=4
autocmd FileType kotlin setlocal cinoptions=+8 " intellij-style continuation indent
autocmd BufReadPost *ServerApplication.kt setlocal paste

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
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"    imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

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

