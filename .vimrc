"
" Vundle + plugins
"
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'wincent/command-t'
Plugin 'vim-syntastic/syntastic'
Plugin 'preservim/nerdtree'
Plugin 'sheerun/vim-polyglot'
call vundle#end()

filetype plugin indent on


"
" General
"
set showtabline=2

set ruler
set number

set tabstop=2
set shiftwidth=2

map \R :source $HOME/.vimrc<CR>


"
" Syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


"
" NERDTree
"
map <C-n> :NERDTreeToggle<CR>

