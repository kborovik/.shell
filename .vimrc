" General Settings
set nocompatible
set updatetime=100

" Set custom leader key
map <Space> <Leader>

" Convert TAB to spaces (2)
set autoindent
set noexpandtab
set shiftwidth=2
set tabstop=2

" Enable file type detection
filetype on
filetype indent on
filetype plugin on
autocmd BufRead ~/.kube/config set syntax=yaml

" Set color scheme
set termguicolors
set background=dark
syntax on
colorscheme catppuccin_macchiato
if &diff
  syntax off
endif

" Map show hidden characters
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,space:.
nmap <F3> :set list! list? <CR>

" Map search settings
set ignorecase
set smartcase
set incsearch
nmap <F4> :set hlsearch! hlsearch? <CR>

" Map spell settings
set spelllang=en_us
nmap <F5> :set spell! spell? <CR>

" Map quit all windows
nmap <F12> :silent! quitall! <CR>

" Map git mergetool
if &diff
  nmap <leader>1 :diffget LOCAL<CR>
  nmap <leader>2 :diffget BASE<CR>
  nmap <leader>3 :diffget REMOTE<CR>
endif

" Enable command menu's
set wildmenu
set wildmode=full
source $VIMRUNTIME/menu.vim

" Configure info settings
set number relativenumber
set signcolumn=yes
set laststatus=2
set statusline=%<%f%m%r\ \[%l/%c]\ \%y%=[%p%%]

" Set cursor
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Set scroll
set nowrap
set scrolloff=10
set sidescrolloff=10
set whichwrap=b,s,<,>

" Set swap dir
set directory=/tmp

" Enable backspace
set backspace=indent,eol,start

" Disable netrwhist
let g:netrw_dirhistmax = 0
