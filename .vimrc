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
Plugin 'mxw/vim-jsx'
Plugin 'bling/vim-airline'
Plugin 'bling/vim-bufferline'
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
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['**.*.js']

let mapleader = ","

"Pymode
let g:pymode_lint_checkers = ['pylint']
let g:pymode_lint = 1
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>run'
let g:pymode_rope = 0
let g:pymode_lint_ignore = 'C0301,E501,W0511, C0111, W0621'

"Collect static files
nmap <silent><leader>cs :!python manage.py collectstatic<cr>

"Paste shortcuts
nmap <silent><leader>sp :set paste<cr>
nmap <silent><leader>snp :set nopaste<cr>

"emmet stuff
let g:user_emmet_leader_key='<C-N>'

" Quick open todo
nmap <silent><leader>tt :sp note:todo<cr>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <CR> :noh<CR><CR>

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

au FileType javascript call JavaScriptFold()

" Sexier tab bar
" Allow buffers at the top (used with vim-bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#tab_nr_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  "following line unfolds all folds when opening file
  au BufRead * normal zR
endif
