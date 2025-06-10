-- Disable annoying temp files
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = false

-- Basic UI Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.o.mouse = "a"

-- Set leader key
vim.g.mapleader = " "

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colorscheme
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end,
    },

    -- Core dependencies
    "nvim-lua/plenary.nvim",

    -- Fuzzy finder
    "nvim-telescope/telescope.nvim",

    -- File explorer
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",

    -- Status line
    "nvim-lualine/lualine.nvim",

    -- LSP and autocompletion
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- CSV formatting plugin
    {
        "chrisbra/csv.vim",
        ft = "csv",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "csv",
                callback = function()
                    vim.cmd("Columnize")
                end,
            })
        end,
    },

    -- OSC52 clipboard support
    {
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup()
            local function copy()
                if vim.v.event.operator == "y" and vim.v.event.regname == "" then
                    require("osc52").copy_register("")
                end
            end
            vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
        end,
    },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- File Explorer config
require("nvim-tree").setup()

-- Status Line
require("lualine").setup {
    options = { theme = "auto" }
}

-- Treesitter
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { "lua", "python", "cpp", "bash", "json" },
}

-- LSP config (Python example)
require("lspconfig").pyright.setup {}

-- Completion
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
