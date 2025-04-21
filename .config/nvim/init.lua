-- Init.lua with improved organization and requested features

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Helper function for key mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Basic settings
vim.g.mapleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.synmaxcol = 10000

-- Clipboard settings
vim.opt.clipboard:append { "unnamedplus" }
vim.opt.shortmess:append("A")

-- Editor settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.conceallevel = 3
vim.opt.hidden = true

-- Visual and Search Improvements
vim.opt.relativenumber = false  -- Easier navigation with relative line numbers
vim.opt.scrolloff = 8           -- Keep context when scrolling
vim.opt.signcolumn = "yes"      -- Always show the sign column
vim.opt.ignorecase = true       -- Case insensitive search
vim.opt.smartcase = true        -- Unless you type an uppercase character
-- vim.opt.cursorline = true       -- Highlight current line

-- Swap and undo settings
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.foldenable = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo/"

-- Mouse configuration
vim.opt.mouse = "a"  -- Enable mouse in all modes
vim.opt.mousemodel = "popup_setpos"  -- Right-click opens context menu

-- Plugin setup
require("lazy").setup({
    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
          "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {
                git = {
                    ignore = false,
                    enable = false
                },
                filters = {
                    custom = {
                        "^.git$",
                        "^.obsidian$",
                        "^.Trash.*$"
                    }
                }
            }
        end,
    },
    
    -- Treesitter for better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "markdown", "bash" },
                highlight = {
                    enable = true,
                },
            })
            
        end,
    },
    
    -- Commentary plugin
    {
        "tpope/vim-commentary"
    },
    
    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        },
    },
    
    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = true,
    },


    {
      "folke/tokyonight.nvim",
      config = function()
        require("tokyonight").setup({
          style = "night", -- The darkest variant
          transparent = true, -- Uses terminal background
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = false },
            functions = {},
            variables = {}
          }
        })
        vim.cmd.colorscheme("tokyonight")
      end
    }
})

-- Key mappings (using the helper function for new mappings)
map("!", "<C-h>", "<C-w>")
map("n", "L", "ciw")
map("n", "<BS>", "<C-o>")
map("n", "K", ":nohlsearch<CR><Esc>")
map("n", "<C-c>", ":Commentary<CR><Esc>")
map("v", "<C-c>", ":Commentary<CR><Esc>")

-- NvimTree mappings
map("n", "<C-n>", ":NvimTreeFindFileToggle %:p:h<CR><Esc>")
map("n", "<C-h>", ":NvimTreeOpen %:p:h<CR><Esc>")
map("n", "<C-l>", ":NvimTreeClose<CR><Esc>")

map("n", "W", "viwo<Esc>~h")
map("n", "M", ":!run %<CR>")
map("n", "<leader>q", ":q!<CR>")
map("n", "<leader>w", ":w!<CR>")
map("n", "gx", ":!xdg-open <C-R><C-A><CR><Esc>")
map("n", "0", "^")

-- Remember cursor position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.fn.setpos(".", vim.fn.getpos("'\""))
            vim.cmd("normal! zv")  -- Open fold if cursor is inside one
        end
    end,
})

-- NvimTree expand all on open
local api = require("nvim-tree.api")
local Event = api.events.Event
api.events.subscribe(Event.TreeOpen, function()
    api.tree.expand_all()
end)

-- Markdown template for new posts
vim.api.nvim_create_augroup("MdTemplateAutoCmd", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
  group = "MdTemplateAutoCmd",
  pattern = vim.fn.expand("~") .. "/.local/src/carterpage/content/posts/*.md",
  callback = function()
    local filename = vim.fn.expand("%:t:r")
    local title = filename:gsub("-", " "):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
    local date = os.date("%Y-%m-%d")
    local lines = {
      "---",
      'title: "' .. title .. '"',
      "date: " .. date,
      "---",
      ""
    }
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
    vim.cmd("normal! G")
    vim.cmd("startinsert")
  end
})

-- Number selected lines with Ctrl-n
vim.api.nvim_create_user_command('NumberMarkdownList', function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    
    local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
    
    for i, line in ipairs(lines) do
        line = line:gsub("^%s*[%d-*+]+%.?%s*", "")
        line = line:gsub("^%s*(.-)%s*$", "%1")
        if line ~= "" then
            lines[i] = i .. ". " .. line
        end
    end
    
    vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, lines)
end, {range = true})
map('v', '<C-n>', ':NumberMarkdownList<CR>')
