" enables syntax highlighting, indentation in pre-v8 Vim
syntax enable
filetype plugin indent on

" Ensure <leader> is backslash
let mapleader="\\"

"
" Plugin related setup - requires sourcing the core-plugins.vim file first
" within a `call plug#begin('~/.vim/plugged') .. call#end('~/.vim/plugged')`
" block
"

colorscheme tender

" Plugin shortcuts
nnoremap <leader>F :NERDTreeToggle<CR>
nnoremap <leader>// :FZF<CR>

" Settings for vim-markdown
let g:vim_markdown_folding_style_pythonic = 1

" end plugin-related

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
set nu
set cursorcolumn " Include visual column cursor

" makes vim look for tags only in ./tags
set tags=tags

" ignores swap files in Vim
" (one tip from this really good video: https://www.youtube.com/watch?v=Gs1VDYnS-Ac )
set noswapfile

" substitutes grep with ack
" this is less useful once using fzf, and could be replaced with ripgrep
set grepprg=ack\ --nogroup\ --column\ --ignore-dir\ node_modules\ --ignore-dir\ log\ $*
set grepformat=%f:%l:%c:%m

" enables search highlighting and 'first match preview'
set hlsearch
set incsearch

" enable British spell checking
augroup Spelling
 autocmd BufRead,BufNewFile *.sql,*.markdown,*.md setlocal spell spelllang=en_gb
augroup end

" enables the default matchit plugin shipped with vim. this enhances the `%`
" command to match start and end of things like html tags and method definitions.
runtime macros/matchit.vim

" Disable autocomplete in all files because it slows Vim down massively
" (I have disabled CoC entirely)
" autocmd FileType * let b:coc_suggest_disable=1

highlight MarkTodos ctermbg=yellow guibg=yellow ctermfg=darkgrey  guifg=darkgrey
match MarkTodos /\* \[[ *x]\]/

augroup Todos
  autocmd BufEnter *.md,*.markdown match MarkTodos /\* \[[ *x]\]/
  autocmd InsertLeave *.md,*.markdown match MarkTodos /\* \[[ *x]\]/
augroup end

" My macros for opening and editing journal entries for today
function! JournalTodayVertical()
  let filename = strftime("~/journal/%Y-%m-%d.markdown")
  echo "Opened journal: " . filename
  execute "vsplit" filename
endfunction

function! ToDo()
  let filename = strftime("~/journal/todos.markdown")
  echo "To do: " . filename
  execute "tabedit" filename
endfunction

function! JournalToday()
  let filename = strftime("~/journal/%Y-%m-%d.markdown")
  echo "Opened journal: " . filename
  execute "split" filename
endfunction

function! CookingToday()
  let filename = strftime("~/journal/cooking/%Y-%m-%d.markdown")
  echo "Opened cooking journal: " . filename
  execute "split" filename
endfunction

function! ProfanityTypos()
  echo "Opened profanity file"
  execute "split" "~/journal/profanities.txt"
endfunction

"
" MAPPINGS
"

" Executing a function is literal: enter command-line mode, enter call and the
" function name, and press return
nnoremap <leader>jT :call JournalTodayVertical()<CR>
nnoremap <leader>jt :call JournalToday()<CR>
nnoremap <leader>jm :call CookingToday()<CR>
nnoremap <leader>PP :call ProfanityTypos()<CR>
nnoremap <leader>dd :call ToDo()<CR>

" Quicker highlight disabling
nnoremap <leader>nn :noh<CR>

" Open in a new tab shortcuts, start `t`
nnoremap <leader>tc :tabe ~/Code<CR>
nnoremap <leader>tv :tabe ~/.config/nvim/init.vim<CR>
nnoremap <leader>tz :tabe ~/.zshrc<CR>
nnoremap <leader>tgg :tabe ~/.gitconfig<CR>
nnoremap <leader>tgi :tabe ~/.gitignore_global<CR>

" Update Plugged and plugins on startup
" PlugUpgrade
" PlugUpdate
