-- Disable annoying temp files
vim.o.swapfile = false         -- No .swp files
vim.o.backup = false           -- No backup files
vim.o.writebackup = false      -- No write backups
vim.o.undofile = false         -- No persistent undo history

-- Basic UI Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true    -- Enable true color support
vim.o.mouse = "a"              -- Enable mouse support

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colorscheme: TokyoNight
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end,
    },
    -- Core dependencies
    "nvim-lua/plenary.nvim",
    -- Telescope fuzzy finder
    "nvim-telescope/telescope.nvim",
    -- File explorer
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",
    -- Status bar
    "nvim-lualine/lualine.nvim",
    -- LSP and completion
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- Keymaps
vim.g.mapleader = " " -- Set <leader> to Space
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- File Explorer
require("nvim-tree").setup()

-- Status Bar
require("lualine").setup {
    options = { theme = "auto" }
}

-- Treesitter Syntax Highlight
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { "lua", "python", "cpp", "bash", "json" },
}

-- LSP (Python Example)
require("lspconfig").pyright.setup {}

-- Autocompletion Setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }),
})

