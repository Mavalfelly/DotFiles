-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- VIM SETTINGS
-- Better editing experience
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easier navigation
vim.opt.cursorline = true -- Highlight the current line
vim.opt.wrap = true -- Enable line wrapping (you already have this)
vim.opt.linebreak = true -- Wrap on word boundaries
vim.opt.showbreak = "↪ " -- Show arrow at line wrap start

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces per indentation level
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.smartindent = true -- Auto-indent new lines intelligently

-- Searching
vim.opt.ignorecase = true -- Case-insensitive search...
vim.opt.smartcase = true -- ... unless uppercase letters are used
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show matches as you type

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for all operations

-- UI & performance
vim.opt.signcolumn = "yes" -- Always show the sign column (for LSP, Git, etc)
vim.opt.termguicolors = true -- Enable 24-bit color support
vim.opt.updatetime = 300 -- Faster completion and CursorHold events (default 4000ms)

-- Files and backups
vim.opt.swapfile = false -- Disable swap files (optional)
vim.opt.backup = false -- Disable backup files (optional)
vim.opt.undofile = true -- Enable persistent undo history
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Set undo directory

-- Split windows
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below
