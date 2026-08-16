-- lua/config/lsp.lua
local M = {}

-- Broadcast nvim-cmp completion capabilities to every LSP client.
local function make_capabilities()
	local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		return cmp_lsp.default_capabilities()
	end
	return vim.lsp.protocol.make_client_capabilities()
end

----------------------------------------------------------------------
-- Typescript Tools Configuration
----------------------------------------------------------------------
function M.setup_typescript()
	require("typescript-tools").setup({
		capabilities = make_capabilities(),
		on_attach = function(client)
			-- Delegate formatting to conform/prettier
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
end

----------------------------------------------------------------------
-- Core LSP, Mason, and Conform Configuration
----------------------------------------------------------------------
function M.setup_servers()
	-- 1. Mason Setup
	require("mason").setup()

	require("mason-lspconfig").setup({
		ensure_installed = {
			"eslint",
			"svelte",
			"html",
			"lemminx",
			"gopls",
			"pyright",
			"lua_ls",
			"jsonls",
		},
	})

	require("mason-tool-installer").setup({
		ensure_installed = { "prettier", "stylua" },
		auto_update = true,
		run_on_start = true,
	})

	-- 2. LSP Server Configurations (Native API)
	local capabilities = make_capabilities()
	local svg_custom_data = vim.fn.stdpath("config") .. "/lua/config/html-custom-data/svg.json"

	-- ESLint
	vim.lsp.config("eslint", {
		capabilities = capabilities,
		settings = { workingDirectory = { mode = "auto" } },
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
		end,
	})
	vim.lsp.enable("eslint")

	-- Svelte
	vim.lsp.config("svelte", {
		capabilities = capabilities,
		settings = {
			svelte = {
				plugin = { html = { completions = { enable = true } }, css = { completions = { enable = true } } },
			},
			html = { customData = { svg_custom_data } },
		},
		on_attach = function(client)
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
				callback = function(ctx)
					local root_dir = client.config.root_dir or client.root_dir

					-- Only notify if the saved file belongs to this LSP project
					if root_dir and vim.startswith(ctx.match, root_dir) then
						client:notify("$/onDidChangeTsOrJsFile", {
							uri = vim.uri_from_fname(ctx.match),
						})
					end
				end,
			})

			client.server_capabilities.documentFormattingProvider = false
		end,
	})
	vim.lsp.enable("svelte")

	-- HTML
	vim.lsp.config("html", {
		capabilities = capabilities,
		init_options = {
			provideFormatter = false,
			embeddedLanguages = { css = true, javascript = true },
			configurationSection = { "html", "css", "javascript" },
		},
		settings = {
			html = { customData = { svg_custom_data } },
		},
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	})
	vim.lsp.enable("html")

	-- Lemminx (XML) — attaches to .svg via the xml filetype mapping in treesitter.lua
	vim.lsp.config("lemminx", {
		capabilities = capabilities,
	})
	vim.lsp.enable("lemminx")

	-- Go
	vim.lsp.config("gopls", {
		capabilities = capabilities,
		settings = {
			gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true },
		},
	})
	vim.lsp.enable("gopls")

	-- Python
	vim.lsp.config("pyright", { capabilities = capabilities })
	vim.lsp.enable("pyright")

	-- Lua
	vim.lsp.config("lua_ls", {
		capabilities = capabilities,
		settings = { Lua = { telemetry = { enable = false } } },
	})
	vim.lsp.enable("lua_ls")

	-- JSON
	vim.lsp.config("jsonls", {
		capabilities = capabilities,
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	})
	vim.lsp.enable("jsonls")

	-- 3. Conform Setup (Format on Save)
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
end

return M
