return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"andymass/vim-matchup",
		},
		config = function()
			vim.filetype.add({ extension = { svg = "xml" } })
			vim.treesitter.language.register("xml", "svg")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})

			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufReadPost",
		config = function()
			local textobjects = {
				["at"] = "@element.outer",
				["it"] = "@element.inner",
			}

			for key, capture in pairs(textobjects) do
				vim.keymap.set({ "o", "x" }, key, function()
					require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
				end, { desc = "Select " .. capture })
			end
		end,
	},
}
