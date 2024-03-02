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
vim.opt.termguicolors = true

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
  --  {
  --    "nvim-neorg/neorg",
  --    build = ":Neorg sync-parsers",
  --    lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
  --    -- tag = "*",
  --    dependencies = { "nvim-lua/plenary.nvim" },
  --    config = function()
  --      require("neorg").setup {
  --        load = {
  --          ["core.defaults"] = {}, -- Loads default behaviour
  --          ["core.concealer"] = {}, -- Adds pretty icons to your documents
  --          ["core.dirman"] = { -- Manages Neorg workspaces
  --            config = {
  --              workspaces = {
  --                notes = "~/Notes",
  --              },
  --            },
  --          },
  --        },
  --      }
  --    end,
  --  },
  {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate"
  },
  {
      "rebelot/kanagawa.nvim",  -- neorg needs a colorscheme with treesitter support
  },
  {
      "tpope/vim-commentary"
  },
})

vim.cmd.colorscheme('kanagawa-dragon')

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
vim.api.nvim_set_keymap("n", "M", ":!run %<CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>w", ":w!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gx", ":!xdg-open <C-R><C-A><CR><Esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "0", "^", { noremap = true })

local api = require("nvim-tree.api")
local Event = api.events.Event
api.events.subscribe(Event.TreeOpen, function()
    api.tree.expand_all()
end)
