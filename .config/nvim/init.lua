-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.autoread = true -- Reload file if changed outside
vim.opt.autowrite = true -- Auto save before commands like :next
vim.opt.confirm = true -- Confirm unsaved changes on quit
vim.opt.hidden = true -- Hide buffers with unsaved changes
vim.opt.history = 1000 -- Command history size
vim.opt.lazyredraw = false -- Don't redraw while executing macros

vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.cursorcolumn = false -- Highlight current column
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.showmode = false -- Don't show mode (for statusline plugins)
vim.opt.showcmd = true -- Show incomplete command in statusline
vim.opt.cmdheight = 1 -- Height of command line
vim.opt.laststatus = 3 -- Global statusline
vim.opt.ruler = true -- Show cursor position
vim.opt.scrolloff = 8 -- Min lines to keep above/below cursor
vim.opt.sidescrolloff = 8 -- Min columns to keep left/right of cursor
vim.opt.wrap = true -- Wrap long lines
vim.opt.linebreak = true -- Wrap on word boundaries
vim.opt.showbreak = "↪ " -- Prefix for wrapped lines
vim.opt.fillchars = { eob = " " } -- Hide ~ on empty lines
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.background = "dark" -- Background color scheme
vim.opt.colorcolumn = "80" -- Highlight 80th column
vim.opt.pumheight = 10 -- Max height of popup menu
vim.opt.pumblend = 10 -- Popup transparency
vim.opt.wildmenu = true -- Enhanced command-line completion

vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Spaces per indentation level
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.softtabstop = 2 -- Spaces per tab while editing
vim.opt.smartindent = true -- Smart indent new lines
vim.opt.autoindent = true -- Copy indent from previous line
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth

vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase in query
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show matches as you type
vim.opt.wrapscan = true -- Wrap around searches

vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = false -- Horizontal splits open below
vim.opt.equalalways = true -- Splits auto resize equally
vim.opt.winminheight = 1 -- Minimum window height
vim.opt.winminwidth = 10 -- Minimum window width

vim.opt.swapfile = false -- Disable swap files
vim.opt.backup = false -- Disable backup files
vim.opt.writebackup = false -- Disable write backup
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo" -- Undo directory
vim.opt.undolevels = 1000 -- Undo levels stored

vim.opt.foldenable = true -- Enable folding
vim.opt.foldmethod = "indent" -- Fold by indent
vim.opt.foldlevelstart = 99 -- Open folds by default
vim.opt.foldnestmax = 10 -- Max fold nesting
vim.opt.foldminlines = 1 -- Minimum lines for fold

vim.opt.completeopt = { "menuone", "noselect" } -- Completion options
vim.opt.wildmode = { "longest", "list", "full" } -- Command-line completion mode
vim.opt.shortmess = "filnxtToOc" -- Avoid some messages
vim.opt.timeoutlen = 1000 -- Time to wait for mapped sequence (ms)
vim.opt.ttimeoutlen = 50 -- Time to wait for key code sequence

vim.opt.spell = true -- Disable spell checking by default
vim.opt.spelllang = { "en_us" } -- Spellcheck language

vim.opt.updatetime = 300 -- Faster CursorHold events (default 4000ms)
vim.opt.modeline = true -- Enable modelines
vim.opt.modelines = 5 -- Number of lines to check for modelines
vim.opt.formatoptions = "tcqnj" -- Format options (autoformatting, comments)
vim.opt.scrolljump = 5 -- Minimal scroll jump
vim.opt.scrolloff = 8 -- Lines of context
vim.opt.whichwrap = "bs<>[]hl" -- Allow cursor to move to next/prev line with these keys
vim.opt.splitkeep = "screen" -- Keep screen stable when splitting (Neovim 0.9+)
