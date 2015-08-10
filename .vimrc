"Note to self: Check out the base16 repo if vim colorschemes are weird
""Vundle start
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'mattn/emmet-vim'
Plugin 'klen/python-mode'
Plugin 'AutoComplPop'
Plugin 'vim-sensible'
Plugin 'chriskempson/base16-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'davidhalter/jedi-vim'  " Must come after python-mode
Plugin 'scrooloose/syntastic'
call vundle#end() 
filetype plugin indent on
"Vundle end
set t_Co=256
set term=screen-256color
syntax on
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

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let mapleader = ","

"Pymode
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>run'
let g:pymode_rope = 0
"
"Collect static files
nmap <silent><leader>cs :!python manage.py collectstatic<cr>

"emmet stuff
let g:user_emmet_leader_key='<C-N>'

"vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <CR> :noh<CR><CR>

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  "following line unfolds all folds when opening file
  au BufRead * normal zR
endif
