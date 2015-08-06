"Note to self: Check out the base16 repo if vim colorschemes are weird
""Vundle start
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'mattn/emmet-vim'
Plugin 'AutoComplPop'
Plugin 'vim-sensible'
Plugin 'jelera/vim-javascript-syntax'
call vundle#end() 
filetype plugin indent on
"Vundle end
set t_Co=256
set term=screen-256color
syntax on
"colorscheme tomorrow-night
set background=light
colorscheme base16-atelierdune
set clipboard=unnamed
set backspace=indent,eol,start
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nosmartindent
set statusline=%l
set statusline+=/
set statusline+=%L
nnoremap <space> za
vnoremap <space> zf
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2

set statusline+=%#warningmsg#
set statusline+=%*

"emmet stuff
let g:user_emmet_leader_key='<C-N>'

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <CR> :noh<CR><CR>

au FileType javascript call JavaScriptFold()

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  "following line unfolds all folds when opening file
  au BufRead * normal zR
endif
