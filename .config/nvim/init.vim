let mapleader=","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'

call plug#end()

lua << EOF
require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/notes",
                },
            },
        },
    },
    tag = "7.0.0", -- Setting a specific version of Neorg
}
EOF

set clipboard+=unnamedplus

set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set noswapfile
set autoread
set undofile
set nofoldenable
set undodir=~/.config/nvim/undo/

noremap! <C-h> <C-w>
nnoremap L ciw
nnoremap K :nohlsearch<CR><Esc>
nnoremap W viwo<Esc>~h
nnoremap <leader>q :q!<CR>
nnoremap <leader>w :w!<CR>
nnoremap gx :!xdg-open <C-R><C-A><CR><Esc>
nnoremap 0 ^

colorscheme habamax
