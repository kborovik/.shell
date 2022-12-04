" General Settings
set nocompatible
set number

" Convert TAB to spaces (2)
set autoindent
set expandtab
set shiftwidth=2
set tabstop=2

" Enable file type detection
filetype on
filetype indent on
filetype plugin on

" Set color scheme
set termguicolors
set background=dark
syntax on
colorscheme onehalfdark

" Show hidden characters
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,space:.
map <F3> :set list! list? <CR>

" Search settings
set ignorecase
set smartcase
set incsearch
map <F4> :set hlsearch! hlsearch? <CR>

" Spell settings
set spelllang=en_us
map <F5> :set spell! spell? <CR>

" Enable command menu's
set wildmenu
set wildmode=full
source $VIMRUNTIME/menu.vim

" Set status line
set laststatus=2
set statusline=%<%f%m%r%=%y\ \[%l/%c]\ \[%p%%]

" Set cursor
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Set scroll
set nowrap
set scrolloff=7
set sidescrolloff=10
set whichwrap=b,s,<,>

" Set swap dir
set directory=~/tmp

" Enable backspace
set backspace=indent,eol,start

" Disable netrw_dir 
:let g:netrw_dirhistmax = 0
