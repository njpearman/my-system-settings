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
