"Note to self: Check out the base16 repo if vim colorschemes are weird
""Vundle start
set nocompatible
set runtimepath^=~/.vim/bundle/ctrlp.vim
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-sensible'
Plugin 'chriskempson/base16-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'davidhalter/jedi-vim'  " Must come after python-mode
Plugin 'scrooloose/syntastic' " use with something like flake8
Plugin 'mxw/vim-jsx'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe' " remember to run install.py. see README.
Plugin 'kien/ctrlp.vim'
Plugin 'dracula/vim'
Plugin 'chase/vim-ansible-yaml'
Plugin 'vimwiki/vimwiki'
Plugin 'ervandew/supertab'
Plugin 'sudar/vim-arduino-syntax'
Plugin 'scrooloose/nerdcommenter'
call vundle#end() 
filetype plugin on
filetype plugin indent on
"Vundle end
set t_Co=256
set term=screen-256color
syntax on
"set background=light
"colorscheme base16-atelierdune
colorscheme dracula
set nu
set clipboard=unnamed
set backspace=indent,eol,start
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=160
set nosmartindent
set mouse=a
set statusline=%l
set statusline+=/
set statusline+=%L
set wildignore+=*/node_modules/*
set tags=tags;
nnoremap <space> za
vnoremap <space> zf
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype css setlocal ts=2 sts=2 sw=2
autocmd Filetype sh setlocal  ts=2 sts=2 sw=2
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2
autocmd Filetype arduino setlocal ts=2 sts=2 sw=2
autocmd Filetype text setlocal ts=2 sts=2 sw=2 tw=180
autocmd Filetype vimwiki setlocal ts=2 sts=2 sw=2 tw=179
au BufRead,BufNewFile *.md setlocal textwidth=80

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['**.*.js']
let g:syntastic_python_flake8_args="--max-line-length=120"
let g:syntastic_python_checkers = ['flake8']

let mapleader = "\<Space>"

"Collect static files
nmap <silent><leader>cs :!python manage.py collectstatic<cr>

"Delete buffer
nmap <silent><leader>d :bd<cr>

"Paste shortcuts
nmap <silent><leader>sp :set paste<cr>
nmap <silent><leader>snp :set nopaste<cr>

"tag
nmap <silent><leader>tg :tselect <C-R><C-W><cr>

"supertab. scroll from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"

" Quick open todo
nmap <silent><leader>tt :e ~/note:todo<cr>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <CR> :noh<CR><CR>

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

au FileType javascript call JavaScriptFold()

" Sexier tab bar
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
let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_z=''

autocmd BufWritePre *.js :%s/\s\+$//e

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  "following line unfolds all folds when opening file
  au BufRead * normal zR
endif

"Ctrlp
"Clear cache before loading ctrlp
nnoremap <silent> <leader>p :ClearCtrlPCache<cr>\|:CtrlPMRU<cr>
"Ignore some directories. Don't forget to escape |
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|coverage_html_report'
let g:ctrlp_working_path_mode = 'ar'

" Set paste in visual mode such that pasted over word goes to black hole
" register
xnoremap p "_dP

let g:ycm_filetype_specific_completion_to_disable = {
    \ 'gitcommit': 1,
    \ 'javascript': 1
    \}

"fix crontab
au FileType crontab setlocal bkc=yes

"Don't run syntasitc automatically while saving python files
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "active_filetypes": [],
    \ "passive_filetypes": ["python"] }
nnoremap <silent> <leader>sc :SyntasticCheck<cr>
nnoremap <silent> <leader>sr :SyntasticReset<cr>
