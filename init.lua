-- Disable annoying temp files
vim.o.swapfile     = false
vim.o.backup       = false
vim.o.writebackup  = false
vim.o.undofile     = false

-- Basic UI Settings
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.termguicolors  = true
vim.o.mouse            = "a"

-- Set leader key
vim.g.mapleader = " "

-- Clipboard: make y/yank use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Gemini AI: Auto-reload files when they change on disk
-- This section makes Neovim automatically reload files if they are
-- changed by an external program. This is useful when you are running
-- a code generator, switching git branches, or using other tools that
-- modify files in the background.
vim.o.autoread = true -- Enable the basic autoread functionality.
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = vim.api.nvim_create_augroup("auto_reload_on_change", { clear = true }),
  pattern = "*",
  callback = function()
    -- This command checks the timestamp of the file on disk. If it's
    -- more recent than the buffer's timestamp, Neovim will reload it.
    -- We only run this in normal mode to avoid interruptions.
    if vim.fn.mode() == "n" then
      vim.cmd("checktime")
    end
  end,
  desc = "Automatically reload files when they change on disk.",
})


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 1) Colorscheme:
  {
         "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end, },

  -- 2) Core dependencies
  "nvim-lua/plenary.nvim",

  -- 3) Fuzzy finder
  "nvim-telescope/telescope.nvim",

  -- 4) File explorer + icons
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",

  -- 5) Status line
  "nvim-lualine/lualine.nvim",

  -- 6) Buffer tabs
  {
    "akinsho/bufferline.nvim",
    version      = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "ordinal", -- <== 🆕 This shows buffer numbers like 1, 2, 3
          diagnostics             = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon         = false,
          separator_style         = "slant",
          offsets = {
            {
              filetype   = "NvimTree",
              text       = "Explorer",
              highlight  = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  -- 7) CSV alignment & highlighting
  {
    "cameron-wags/rainbow_csv.nvim",
    ft = { "csv", "tsv" },
    config = function()
      vim.keymap.set("n", "<leader>ra", ":RainbowAlign<CR>",
        { noremap = true, silent = true, desc = "Align CSV columns" })
    end,
  },

  -- 8) LSP + completion
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- 9) Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- Keymaps
vim.keymap.set("n", "<leader>e",  ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>",   { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>",    { noremap = true, silent = true })

-- Plugin configs that need to be loaded after setup:
-- Nvim Tree
require("nvim-tree").setup()

-- Lualine
require("lualine").setup { options = { theme = "auto" } }

-- Treesitter configs
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent    = { enable = true },
  ensure_installed = { "lua", "python", "cpp", "bash", "json" },
}

-- LSP (example: Pyright)
require("lspconfig").pyright.setup {}

-- Completion setup
local cmp     = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"]    = cmp.mapping.select_next_item(),
    ["<S-Tab>"]  = cmp.mapping.select_prev_item(),
    ["<CR>"]     = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip"  },
  }),
})
