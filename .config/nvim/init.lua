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

-- Set leader key
vim.g.mapleader = ","

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
-- vim.opt.termguicolors = true
vim.opt.synmaxcol = 0

require("lazy").setup({
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
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate"
  },
  {
      "tpope/vim-commentary"
  },
})

vim.cmd.colorscheme("vim")

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

-- Swap and undo settings
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.foldenable = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo/"

-- Key mappings
vim.api.nvim_set_keymap("!", "<C-h>", "<C-w>", { noremap = true })
vim.api.nvim_set_keymap("n", "L", "ciw", { noremap = true })
vim.api.nvim_set_keymap("n", "<BS>", "<C-o>", { noremap = true })
vim.api.nvim_set_keymap("n", "K", ":nohlsearch<CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":Commentary<CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-c>", ":Commentary<CR><Esc>", { noremap = true })

-- NvimTree
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeFindFileToggle %:p:h<CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeOpen %:p:h<CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":NvimTreeClose<CR><Esc>", { noremap = true })

vim.api.nvim_set_keymap("n", "W", "viwo<Esc>~h", { noremap = true })
vim.api.nvim_set_keymap("n", "M", ":!run %<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>w", ":w!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gx", ":!xdg-open <C-R><C-A><CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "0", "^", { noremap = true })

vim.api.nvim_set_keymap('', '<C-LeftMouse>', '<nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<C-LeftMouse>', '<nop>', { noremap = true, silent = true })

local api = require("nvim-tree.api")
local Event = api.events.Event
api.events.subscribe(Event.TreeOpen, function()
    api.tree.expand_all()
end)

-- thanks, claude
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
vim.api.nvim_set_keymap('v', '<C-n>', ':NumberMarkdownList<CR>', {noremap = true, silent = true})
