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
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeCompletionsForModuleExports = true,
						quotePreference = "auto",
					},
					tsserver_format_options = {
						indentSize = 2,
						tabSize = 2,
					},
					separate_diagnostic_server = true,
					publish_diagnostic_on = "insert_leave",
				},
			})
		end,
	},

	----------------------------------------------------------------------
	-- nvim-lspconfig + mason + conform + lazydev setup
	----------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"stevearc/conform.nvim",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			----------------------------------------------------------------------
			-- Mason & Tool Installation
			----------------------------------------------------------------------
			require("mason").setup()

			-- 1. Language Servers
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint",
					"svelte",
					"gopls",
					"pyright",
					"lua_ls",
				},
			})

			-- 2. Formatters & Linters
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylua",
				},
				auto_update = true,
				run_on_start = true,
			})

			----------------------------------------------------------------------
			-- LSP Server Configurations (Neovim 0.11+ Native API)
			----------------------------------------------------------------------

			-- ESLint (lint only, no formatting)
			vim.lsp.config("eslint", {
				settings = { workingDirectory = { mode = "auto" } },
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})
			vim.lsp.enable("eslint")

			-- Svelte (disable formatting → use Prettier)
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

			-- Go (keep formatter)
			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						analyses = { unusedparams = true, shadow = true },
						staticcheck = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			-- Python (fallback only)
			vim.lsp.config("pyright", {})
			vim.lsp.enable("pyright")

			-- Lua (lazydev handles Neovim-specific workspace/diagnostics settings)
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.enable("lua_ls")

			----------------------------------------------------------------------
			-- Conform (Prettier + StyLua + fallback)
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
					lua = { "stylua" },
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
						lua = true,
					}
					return {
						timeout_ms = 500,
						lsp_format = no_fallback[ft] and "never" or "fallback",
					}
				end,
			})

			----------------------------------------------------------------------
			-- LSP Attach (Keymaps & Completion)
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
				end,
			})
		end,
	},
}
