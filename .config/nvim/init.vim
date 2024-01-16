let mapleader=","

set clipboard+=unnamedplus

set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set noswapfile
set autoread
set undofile
set undodir=~/.config/nvim/undo/



nnoremap L ciw
nnoremap K :nohlsearch<CR><Esc>
nnoremap W viwo<Esc>~h
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w!<CR>
nnoremap gx :!xdg-open <C-R><C-A><CR><Esc>

colorscheme gruvbox
