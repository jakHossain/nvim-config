-- lua/config/telescope.lua
local M = {}

function M.setup()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			file_ignore_patterns = {
				"^%.git/",
			},
			mappings = {
				i = {
					-- Instant Escape
					["<Esc>"] = actions.close,
					["jk"] = actions.close,
				},
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- Uses a clean dropdown theme for code actions/renames
				}),
			},
		},
	})

	-- Load Extensions
	telescope.load_extension("fzf")
	telescope.load_extension("ui-select")
end

return M
