" enables syntax highlighting, indentation in pre-v8 Vim
syntax on
filetype plugin indent on

" loads directories into vim's path. these are all patterns useful in a rails
" app.
set path+=app/**
set path+=config/**
set path+=db/**
set path+=spec/**

" sets tab indentation, etc.
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" makes vim look for tags only in ./tags
set tags=tags

" substitutes grep with ack
set grepprg=ack\ --nogroup\ --column\ --ignore-dir\ node_modules\ --ignore-dir\ log\ $*
set grepformat=%f:%l:%c:%m

" enables search highlighting and 'first match preview'
set hlsearch
set incsearch

" enables the default matchit plugin shipped with vim. this enhances the `%`
" command to match start and end of things like html tags and method definitions.
runtime macros/matchit.vim
