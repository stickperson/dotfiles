"Vundle start
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'mattn/emmet-vim'
Plugin 'AutoComplPop'
Plugin 'syntastic'
Plugin 'vim-sensible'
call vundle#end() 
filetype plugin indent on
"Vundle end
set t_Co=256
set term=screen-256color
execute pathogen#infect()
execute pathogen#helptags()
syntax on
colorscheme tomorrow-night
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
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"disable scss checker
let g:syntastic_scss_checkers = ['']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

"emmet stuff
let g:user_emmet_leader_key='<C-N>'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

let g:syntastic_python_flake8_args = "--ignore=E501"
let syntastic_mode_map = { 'passive_filetypes': ['html'] }

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <CR> :noh<CR><CR>

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif
