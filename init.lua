-- ===================================================================
--  Your Basic Settings (Unchanged)
-- ===================================================================
vim.o.swapfile      = false
vim.o.backup        = false
vim.o.writebackup   = false
vim.o.undofile      = false

-- Basic UI Settings
vim.opt.number          = true
vim.opt.relativenumber  = true
vim.opt.tabstop         = 4
vim.opt.shiftwidth      = 4
vim.opt.expandtab       = true
vim.opt.smartindent     = true
vim.opt.termguicolors   = true
vim.o.mouse             = "a"

-- Set leader key
vim.g.mapleader = " "

-- Clipboard: make y/yank use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Gemini AI: Auto-reload files when they change on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = vim.api.nvim_create_augroup("auto_reload_on_change", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.mode() == "n" then
      vim.cmd("checktime")
    end
  end,
  desc = "Automatically reload files when they change on disk.",
})

-- ===================================================================
--  Bootstrap lazy.nvim (Unchanged)
-- ===================================================================
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===================================================================
--  Lazy Plugin List (UPDATED)
-- ===================================================================
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
          numbers = "ordinal", 
          diagnostics            = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon       = false,
          separator_style       = "slant",
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

  -- 8) LSP + completion (Unchanged)
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- 9) Treesitter (Unchanged)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- =================================================================
  --  NEW PLUGINS FOR C# AND UNITY
  -- =================================================================
  
  -- 10) MASON: Installs LSPs, DAPs, linters, etc.
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  
  -- 11) MASON-LSPCONFIG: Bridges mason and lspconfig
  { "williamboman/mason-lspconfig.nvim" },

  -- 12) DAP: The main debugging plugin
  { "mfussenegger/nvim-dap" },

  -- 13) MASON-DAP: Bridges mason and the DAP
  { "williamboman/mason-nvim-dap.nvim" },

  -- 14) CSHARP.NVIM: Auto-configures C# LSP and Debugging
  {
    "iabdelkareem/csharp.nvim",
    ft = "cs", -- Only load for C# files
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Tell mason to install the .NET debugger
      require("mason-nvim-dap").setup({
        ensure_installed = { "netcoredbg" },
      })
      
      -- Setup csharp.nvim
      require("csharp").setup({
        lsp = true, -- Auto-configure the LSP
        dap = true, -- Auto-configure the Debugger
      })
    end,
  },
  
}) -- END OF lazy.setup

-- ===================================================================
--  Keymaps (Unchanged)
-- ===================================================================
vim.keymap.set("n", "<leader>e",  ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>",   { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>",    { noremap = true, silent = true })

-- ===================================================================
--  Plugin Configs (UPDATED)
-- ===================================================================

-- Nvim Tree (Unchanged)
require("nvim-tree").setup()

-- Lualine (Unchanged)
require("lualine").setup { options = { theme = "auto" } }

-- Treesitter configs (UPDATED)
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent    = { enable = true },
  ensure_installed = { "lua", "python", "cpp", "bash", "json", "c_sharp" }, -- Added "c_sharp"
}

-- LSP (UPDATED)
-- This will now automatically set up ALL servers you install with Mason
-- (including pyright and csharp_ls)
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "csharp_ls" },
  handlers = {
    -- This is the default handler, it just starts the server
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  },
})

-- Completion setup (Unchanged)
local cmp     = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"]   = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"]    = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip"  },
  }),
})
