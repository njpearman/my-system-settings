" enables syntax highlighting, indentation in pre-v8 Vim
syntax enable
filetype plugin indent on

" Ensure <leader> is backslash
let mapleader="\\"

" Sets up the internal NeoVim language server using a Lua script
" See https://expectationmax.github.io/2020/NeoVims-Language-Server-Client
" lua << EOF
" 30-10-23 I have no idea where this has come from. I should check git
" history.
" require('nvim_lsp').pyls.setup({})
" EOF

autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc

"
" Plugin related setup - requires sourcing the core-plugins.vim file first
" within a `call plug#begin('~/.vim/plugged') .. call#end('~/.vim/plugged')`
" block
"

colorscheme tender

" Plugin shortcuts
nnoremap <leader>F :NERDTreeToggle<CR>
nnoremap <leader>// :FZF<CR>
nnoremap <leader>?? :Rg<CR>

" Edit shortcuts
nnoremap <leader>er :tabe ~/.vimrc<CR>
nnoremap <leader>es :tabe ~/.vim/custom/core.vim<CR>
nnoremap <leader>ez :tabe ~/.zshrc<CR>

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

" Use a 4-space tab for python files
autocmd FileType python set tabstop=4 | set shiftwidth=4 | set expandtab
"autocmd FileType python nnoremap [z [m
"autocmd FileType python nnoremap ]z ]m

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


" Function to open a new blog post in a split panel
function! NewPost()
    let post_name = input('Post title: ')

    " Define the shell command to create the post and fully remove color codes
    let cmd = 'jekyll compose "' . post_name . '" | sed -r "s/\\x1b\\[[0-9;]*m//g" | awk ''/New post created at/ {print $5}'''

    " Run the command and capture the output (file path)
    let file = system(cmd)

    " Trim any extra newlines or whitespace from the output
    let file = substitute(file, '\n', '', 'g')

    " Check if a valid file path was returned
    if empty(file)
        echo "Error: No file path found. This might occur if the title is repeated."
    else
        " Open the new post in a vertical split
        execute 'vsplit ' . file
    endif
endfunction

" Create a custom Vim command to call the function
command! NewPost call NewPost()


"
" MAPPINGS
"

" Executing a function is literal: enter command-line mode, enter call and the
" function name, and press return
nnoremap <leader>jT :call JournalTodayVertical()<CR>
nnoremap <leader>jt :call JournalToday()<CR>
nnoremap <leader>jc :call CookingToday()<CR>
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
