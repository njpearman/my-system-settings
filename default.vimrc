" Set up vim-plug and managed plugins
" Do this first so that they are available in the rest of the file
call plug#begin('~/.vim/plugged')
" Note that paths _do not_ need quotes for sourcing
source ~/.vim/custom/core-plugs.vim
call plug#end()

source ~/.vim/custom/core.vim
source ~/.vim/custom/skiller-whale.vim
