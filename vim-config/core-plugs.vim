" Source this file within the plug section of .vimrc / init.vim
" as per https://github.com/junegunn/vim-plug/issues/425#issuecomment-188404964

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

" A folder explorer
Plug 'preservim/nerdtree'

" Language server (seems like a more complete system
" than ALE, which was another recommendation for Rust)
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" Rust plugin for Vim
Plug 'rust-lang/rust.vim'
