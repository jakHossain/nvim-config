return {
  ----------------------------------------------------------------------
  -- typescript-tools.nvim (replaces ts_ls / typescript-language-server)
  ----------------------------------------------------------------------
  {
    "pmizio/typescript-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          -- match your existing approach: formatting via conform/prettier only
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,

        settings = {
          -- these are first-class settings the plugin documents
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
          tsserver_format_options = {
            indentSize = 2,
            tabSize = 2,
          },

          -- optional documented knobs:
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
        },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- your existing nvim-lspconfig + mason + conform setup
  ----------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "stevearc/conform.nvim",
    },
    config = function()
      ----------------------------------------------------------------------
      -- Mason
      ----------------------------------------------------------------------
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "ts_ls",  -- removed (typescript-tools replaces it)
          "eslint",
          "svelte",
          "gopls",
          "pyright",
        },
      })

      ----------------------------------------------------------------------
      -- ESLint (lint only, no formatting)
      ----------------------------------------------------------------------
      vim.lsp.config("eslint", {
        settings = { workingDirectory = { mode = "auto" } },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
      vim.lsp.enable("eslint")

      ----------------------------------------------------------------------
      -- Svelte (disable formatting → use Prettier)
      ----------------------------------------------------------------------
      vim.lsp.config("svelte", {
        settings = {
          svelte = {
            plugin = {
              html = { completions = { enable = true } },
              css = { completions = { enable = true } },
            },
          },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
      vim.lsp.enable("svelte")

      ----------------------------------------------------------------------
      -- Go (keep formatter)
      ----------------------------------------------------------------------
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
          },
        },
      })
      vim.lsp.enable("gopls")

      ----------------------------------------------------------------------
      -- Python (fallback only)
      ----------------------------------------------------------------------
      vim.lsp.config("pyright", {})
      vim.lsp.enable("pyright")

      ----------------------------------------------------------------------
      -- Conform (Prettier + fallback)
      ----------------------------------------------------------------------
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
        },
        format_on_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          local no_fallback = {
            javascript = true,
            typescript = true,
            javascriptreact = true,
            typescriptreact = true,
            svelte = true,
            html = true,
            css = true,
            json = true,
          }
          return {
            timeout_ms = 500,
            lsp_fallback = not no_fallback[ft],
          }
        end,
      })

      ----------------------------------------------------------------------
      -- LSP Attach
      ----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local client_id = ev.data.client_id

          -- Completion
          vim.lsp.completion.enable(true, client_id, ev.buf, { autotrigger = false })
          vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = ev.buf })

          -- Keymaps
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

          -- Format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
              require("conform").format({
                bufnr = ev.buf,
                timeout_ms = 500,
                lsp_fallback = true,
              })
            end,
          })
        end,
      })
    end,
  },
}
