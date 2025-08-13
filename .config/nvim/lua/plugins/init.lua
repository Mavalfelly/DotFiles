-- ~/.config/nvim/lua/plugins/init.lua
return {
  { "nvim-tree/nvim-tree.lua", enabled = false },
    {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "Workspace Symbol" }
      keys[#keys + 1] = { "<leader>vd", vim.diagnostic.open_float, desc = "Line Diagnostics" }
      keys[#keys + 1] = { "<leader>vca", vim.lsp.buf.code_action, desc = "Code Action" }
      keys[#keys + 1] = { "<leader>vrr", vim.lsp.buf.references, desc = "References" }
      keys[#keys + 1] = { "<leader>vrn", vim.lsp.buf.rename, desc = "Rename" }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright", 
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "marksman",
        "jdtls",
        "dockerls", 
        "yamlls",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    },
  },
}