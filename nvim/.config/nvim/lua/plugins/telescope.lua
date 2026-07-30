-- lua/plugins/telescope.lua
return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim", -- UI Select Extension
	},
	config = function()
		require("config.telescope").setup()
	end,
}
