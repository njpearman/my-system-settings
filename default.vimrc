" Set up vim-plug and managed plugins
" Do this first so that they are available in the rest of the file
call plug#begin('~/.vim/plugged')

" file find and search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" syntax highlighting
Plug 'gabrielelana/vim-markdown'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'

" colour schemes
Plug 'jacoborus/tender.vim'
Plug 'AlessandroYorba/Sierra'

" language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" enables syntax highlighting, indentation in pre-v8 Vim
syntax enable
filetype plugin indent on

colorscheme tender

" loads directories into vim's path. these are all patterns useful in a rails
" app.
" this is less useful once using fzf
set path+=app/**
set path+=bin/**
set path+=config/**
set path+=db/**
set path+=lib/**
set path+=test/**
set path+=spec/**

" sets tab indentation, etc.
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" makes vim look for tags only in ./tags
set tags=tags

" substitutes grep with ack
" this is less useful once using fzf, and could be replaced with ripgrep
set grepprg=ack\ --nogroup\ --column\ --ignore-dir\ node_modules\ --ignore-dir\ log\ $*
set grepformat=%f:%l:%c:%m

" enables search highlighting and 'first match preview'
set hlsearch
set incsearch

" enables the default matchit plugin shipped with vim. this enhances the `%`
" command to match start and end of things like html tags and method definitions.
runtime macros/matchit.vim

function! JournalToday()
  let filename = strftime("~/journal/%Y-%m-%d.markdown")
  echo "Opened journal: " . filename
  execute "vsplit" filename
endfunction

" executing a function is literal: enter command-line mode, enter call and the
" function name, and press return
nnoremap <leader>jt :call JournalToday()<CR>
