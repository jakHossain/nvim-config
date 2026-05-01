return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      ------------------------------------------------------------------
      -- Mason setup
      ------------------------------------------------------------------
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
        },
      })

      ------------------------------------------------------------------
      -- gopls setup
      ------------------------------------------------------------------
      local lspconfig = require("lspconfig")

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      })

      ------------------------------------------------------------------
      -- LSP attach keymaps
      ------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
