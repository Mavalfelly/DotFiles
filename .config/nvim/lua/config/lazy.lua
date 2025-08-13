-- ~/.config/nvim/lua/config/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
    -- Other popular colorschemes you might want to try:
    -- "catppuccin" - Modern and elegant theme with multiple flavors
    -- "gruvbox" - Retro groove color scheme
    -- "nord" - Arctic, north-bluish color palette
    -- "onedark" - Atom's iconic dark theme
    -- "dracula" - Dark theme inspired by Dracula
    -- "nightfox" - Collection of dark themes (nightfox, duskfox, etc.)
    -- "everforest" - Green-based colorscheme
    -- "rose-pine" - Soho vibes for Neovim
    -- "kanagawa" - Dark theme inspired by the Great Wave
    -- "solarized" - Precision colors for machines and people
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin", 
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})