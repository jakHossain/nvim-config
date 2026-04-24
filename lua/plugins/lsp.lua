return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Initialize Mason (The Downloader)
      require("mason").setup()

      -- 2. Tell Mason which servers to auto-install
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "ts_ls", "pyright" },
      })

      -- 3. The New Native Neovim LSP API
      
      -- Go Configuration
      vim.lsp.config("gopls", {
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
      vim.lsp.enable("gopls")

      -- Connect TypeScript and Python
      vim.lsp.config("ts_ls", {})
      vim.lsp.enable("ts_ls")
      
      vim.lsp.config("pyright", {})
      vim.lsp.enable("pyright")
      
      -- 4. Native Neovim Keymaps (Only load when an LSP attaches to a buffer)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Enable native completion, but keep the automatic popup OFF
          local client_id = ev.data.client_id
          vim.lsp.completion.enable(true, client_id, ev.buf, { autotrigger = false })

          -- Map Ctrl+Space to manually open the autocomplete menu in Insert mode ('i')
          vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = ev.buf, desc = "Manual Autocomplete" })

          -- Format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
              -- We strictly set async = false so the formatting finishes 
              -- BEFORE the file is actually written to disk.
              vim.lsp.buf.format({ async = false, id = client_id })
            end,
          })

          -- Press 'gd' to Go to Definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          -- Press 'K' to hover and see documentation for a function
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- Press '<space>rn' to rename a variable across the whole project
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          -- Press gl to view warnings and errors on line
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
