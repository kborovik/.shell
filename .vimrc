" Convert TAB to spaces (2)
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
" set number

" Show hidden characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.
map <F3> :set list! list? <CR>

" Search settings
set ignorecase
set smartcase
set hlsearch
noremap <F4> :set hlsearch! hlsearch? <CR>

" Spell settings
set spelllang=en_us
map <F5> :set spell! spell? <CR>

" Set color scheme
syntax on
colorscheme onehalfdark
