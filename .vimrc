set enc=utf-8

filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Bundle 'gmarik/Vundle.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'scrooloose/nerdcommenter'
" Bundle 'szw/vim-tags'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/lojban'
Bundle 'groenewege/vim-less'
"Bundle 'majutsushi/tagbar'
"Bundle 'ScrollColors'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'pyte'

" let g:vim_tags_project_tags_command = "/usr/local/Cellar/ctags/5.8/bin/ctags --sort=yes -R {OPTIONS} {DIRECTORY} 2>/dev/null &"
" let g:vim_tags_auto_generate = 1

filetype plugin indent on " required!?
autocmd BufRead,BufNewFile * set indentkeys=0{,0},0),0],!^F,o,O,e

" lets ignore some shit directories
set wildignore+=*/vendor/*,*/tmp/*,*/data/*,*/log/*

let g:ctrlp_working_path_mode = 'rac'
let g:ctrlp_cache_dir='~/.vim/ctrlp_cache'
let g:ctrlp_max_files=4000
"let g:ctrlp_map = '<Leader>t'
"let g:ctrlp_match_window_bottom = 0
"let g:ctrlp_match_window_reversed = 0
"let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py|vendor'
let g:ctrlp_dotfiles = 0

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|vendor|tmp|public|data)$',
  \ }

let NERDTreeChDirMode=2

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
noremap Q <Nop>

map <F2> :NERDTreeToggle<RETURN>
map <Leader>n <plug>NERDTreeTabsToggle<CR>

imap <Up> <Nop>
imap <Down> <Nop>
inoremap <Cr> <Esc>
inoremap <Esc> a<Bs><Esc>u
vmap <Up> k
vmap <Down> j
map <Left> h
map <Right> l

noremap . .`[

hi Search term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
highlight ColorColumn ctermbg=lightgray guibg=lightgray
set colorcolumn=80
set showfulltag
set timeout timeoutlen=1000 ttimeoutlen=100

set nocompatible
set cpoptions=Acdesmq$
syntax on

set encoding=utf-8
set backspace=indent,eol,start
set nowritebackup
set noswapfile
set clipboard+=unnamed
set fileformats=unix,dos,mac
set nohidden
set iskeyword+=_,$,@,%,#
set mouse=a

set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set linespace=0
set list
set listchars=tab:>-,trail:~,extends:»,precedes:«
set matchtime=1
set novisualbell
set number
set numberwidth=4
set report=0
set scrolloff=3
set showmatch

set formatoptions=ocql
set ignorecase
set infercase
set nowrap
set expandtab
set shiftround
set shiftwidth=2
set softtabstop=2
set tabstop=8
set smartcase

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" reload vim configuration on write
autocmd! bufwritepost .vimrc source %

set t_Co=256
set background=light
colorscheme pyte
