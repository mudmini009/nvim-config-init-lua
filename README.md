## 🚀 Features

This is a lightweight Neovim configuration built on `lazy.nvim`. It's designed for a clean look with powerful IDE features, especially for Python and C# (Unity) development.

### Core UI & Experience

* **Plugin Manager:** `lazy.nvim`
* **Colorscheme:** `tokyonight.nvim`
* **Status Line:** `lualine.nvim`
* **Buffer Tabs:** `bufferline.nvim`
* **File Explorer:** `nvim-tree.lua`
* **Icons:** `nvim-web-devicons`

### Navigation & Fuzzy Finding

* **Telescope:** For fuzzy finding files (`<leader>ff`), text (`<leader>fg`), and more.
* **NvimTree:** A file explorer sidebar, toggled with `<leader>e`.

### Coding & Language Support

* **LSP Management:** `mason.nvim` and `mason-lspconfig.nvim` to automatically install and configure language servers.
* **Syntax Highlighting:** `nvim-treesitter` for fast and accurate code highlighting.
* **Auto-completion:** `nvim-cmp` provides the completion menu, powered by:
    * `cmp-nvim-lsp` (for code suggestions from the LSP)
    * `cmp_luasnip` (for snippets)
* **Snippet Engine:** `LuaSnip`

### Debugging

* **DAP:** `mfussenegger/nvim-dap` is included for step-through debugging.
* **Debugger Management:** `mason-nvim-dap.nvim` automatically installs debuggers.

### Language-Specific Setups

* **C# (Unity):** `csharp.nvim` automatically configures the `csharp_ls` (LSP) and `netcoredbg` (Debugger) to work seamlessly with Unity projects.
* **Python:** `pyright` (LSP) is installed and managed by Mason.
* **Data (CSV/TSV):** `rainbow_csv.nvim` provides syntax highlighting and column alignment (`<leader>ra`) for CSV files.

### Key Editor Settings

* `leader` key is set to `[Space]`.
* System clipboard integration (`unnamedplus`).
* Automatic file reloading (`autoread`).
* Tabs are set to 4-space soft tabs (`expandtab`).
* Relative line numbers are enabled.
