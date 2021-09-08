" Set up vim-plug and managed plugins
" Do this first so that they are available in the rest of the file
call plug#begin('~/.vim/plugged')

" Some navigation help from Tim Pope
Plug 'tpope/vim-unimpaired'

" file find and search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" syntax highlighting
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Plug 'pangloss/vim-javascript'
" Plug 'leafgarland/typescript-vim'

" colour schemes
Plug 'jacoborus/tender.vim'
" Plug 'AlessandroYorba/Sierra'

" language server
" CoC seems to be the root cause of slowdown in Vim
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" Settings for vim-markdown
let g:vim_markdown_folding_style_pythonic = 1

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

" executing a function is literal: enter command-line mode, enter call and the
" function name, and press return
nnoremap <leader>jT :call JournalTodayVertical()<CR>
nnoremap <leader>jt :call JournalToday()<CR>
nnoremap <leader>jm :call CookingToday()<CR>
nnoremap <leader>PP :call ProfanityTypos()<CR>

" A shortcut to open .vimrc
nnoremap <leader>/ :tabe ~/.config/nvim/init.vim<CR>
nnoremap <leader>' :tabe ~/.zshrc<CR>

" Quicker highlight disabling
nnoremap <leader>nn :noh<CR>

" Update Plugged and plugins on startup
" PlugUpgrade
" PlugUpdate

" **************************
"
" SKILLER WHALE PRODUCTIVITY
"
" **************************

" Use a character to clearly display no-breaking spaces
set list listchars=nbsp:^

function! OpenThisWeek()
  let s:ThisWeek = system("pushd ~/journal; find -E skiller-whale -regex '.*[0-9]{3,}.*' | sort --reverse | head -1")
  execute "split" expand("~/journal/") . s:ThisWeek
  let s:_ = system("popd")
endfunction

function! OpenCurriculumRoot()
  execute "tabe $SW_CURR"
endfunction

function! OpenExercisesRoot()
  execute "tabe $SW_EXER"
endfunction

" Feature to toggle highlighting trailing whitespace
let g:toggleHighlightWhitespace = 1

function! ToggleHighlightWhitespace()
  let g:toggleHighlightWhitespace = 1 - g:toggleHighlightWhitespace
  call RefreshHighlightWhitespace()
  if g:toggleHighlightWhitespace == 1
    echo "Highlight trailing whitespace on"
  else
    echo "Highlight trailing whitespace off"
  endif
endfunction

function! RefreshHighlightWhitespace()
  if g:toggleHighlightWhitespace == 1 " normal action, do the hi
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    augroup HighLightWhitespace
      autocmd BufWinEnter curriculum/* match ExtraWhitespace /\s\+$/
      autocmd InsertLeave curriculum/* match ExtraWhitespace /\s\+$/
      autocmd BufWinLeave curriculum/* call clearmatches()
    augroup end
  else " clear whitespace highlighting
    call clearmatches()
    autocmd! HighLightWhitespace BufWinEnter
    autocmd! HighLightWhitespace InsertLeave
    autocmd! HighLightWhitespace BufWinLeave
  endif
endfunction

function! CleanDataTable()
  substitute /\v^[^|]*\|\s/
endfunction

function! SqlExerciseComment()
  let s:comment = ["/* -----------------------------------------------------------------------------"]
  call add (s:comment, "|")
  call add (s:comment, "|    1. <Slide title goes here>")
  call add (s:comment, "|")
  call add (s:comment, "|    * <write a task here>")
  call add (s:comment, "|")
  call add (s:comment, "*/ -----------------------------------------------------------------------------")
  call append(line("."), s:comment)
endfunction

function! SlideExercise()
  let s:comment = [ "#### Exercise", "", "##### Checklist", "", "* Follow the instructions in `filename`.", ""]
  call append(line("."), s:comment)
endfunction

function! ExerciseQuestionMarkup()
  let s:comment = ["<!--question optional_unique_id_for_a_question_response-->",""]
  call append(line("."), s:comment)
endfunction

function! SlideLearningObjectives()
  let s:comment = ["#### Learning Objectives"]
  call add (s:comment, "")
  call add (s:comment, "* ")
  call add (s:comment, "")
  call append(line("."), s:comment)
endfunction

" I am still struggling to fully understand how to use s and substitute() in
" Vimscript. I want to do this substitution without recording the changes, or
" deleting the records once they have been carried out.
function! RemoveTrailingWhitespace()
  let cursor_pos = getcurpos()
  %s/\s\+$//e
  call setpos('.', cursor_pos)
endfunction

function! RemoveUnbreakableSpaceInHeadings()
  let cursor_pos = getcurpos()
  %s/# /# /e
  call setpos('.', cursor_pos)
endfunction

highlight UnbreakableSpace ctermfg=red guifg=red

augroup skillerwhale
  " Clear the group in case of reload
  autocmd!

  autocmd BufWinEnter * call RefreshHighlightWhitespace()
  autocmd BufWinLeave * call RefreshHighlightWhitespace()
  autocmd BufEnter */curriculum tcd $SW_CURR

  " Remove trailing spaces from lines on save
  autocmd BufWritePre */curriculum/* call RemoveTrailingWhitespace()
  autocmd BufWritePre */curriculum/*.* call RemoveUnbreakableSpaceInHeadings()

  " Highlight no-breaking spaces
  autocmd BufWinEnter,InsertLeave *.md,*.markdown syntax match UnbreakableSpace / /
augroup end

" location navigation
nnoremap <leader>TT :call OpenCurriculumRoot()<CR>
nnoremap <leader>TE :call OpenExercisesRoot()<CR>
nnoremap <leader>Tt :call OpenThisWeek()<CR>

" File editing
nnoremap <leader>W :call ToggleHighlightWhitespace()<cr>
nnoremap <leader>Cs :call SqlExerciseComment()<CR>
nnoremap <leader>Sq :call ExerciseQuestionMarkup()<CR>
nnoremap <leader>Se :call SlideExercise()<CR>
nnoremap <leader>Sl :call SlideLearningObjectives()<CR>

vnoremap TD :call CleanDataTable()<CR><CR>
