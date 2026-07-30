-- lua/plugins/lsp.lua
return {
	----------------------------------------------------------------------
	-- typescript-tools.nvim
	----------------------------------------------------------------------
	{
		"pmizio/typescript-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			-- Call the setup function from our config file
			require("config.lsp").setup_typescript()
		end,
	},

	----------------------------------------------------------------------
	-- LSP + Tooling Ecosystem
	----------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"stevearc/conform.nvim",
			"b0o/SchemaStore.nvim",
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
			-- Call the core servers setup from our config file
			require("config.lsp").setup_servers()
		end,
	},
}
