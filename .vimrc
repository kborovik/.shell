" General Settings
set nocompatible
set updatetime=100

" Set custom leader key
map <Space> <Leader>

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
if &diff
  syntax off
endif

" Git difftool
nmap <F2> :! git difftool % <CR>

" Show hidden characters
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,space:.
nmap <F3> :set list! list? <CR>

" Search settings
set ignorecase
set smartcase
set incsearch
nmap <F4> :set hlsearch! hlsearch? <CR>

" Spell settings
set spelllang=en_us
nmap <F5> :set spell! spell? <CR>

" Quit all windows
nmap <F9> :silent! quitall! <CR>

" Enable command menu's
set wildmenu
set wildmode=full
source $VIMRUNTIME/menu.vim

" Configure info settings
set number
set signcolumn=yes
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

" Disable netrwhist
let g:netrw_dirhistmax = 0
