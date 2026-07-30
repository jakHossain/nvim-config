-- lua/config/nvimtree.lua
local M = {}

function M.setup()
	-- 1. Custom Mappings (Home Row Efficiency)
	local function my_on_attach(bufnr)
		local api = require("nvim-tree.api")

		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end

		-- Default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- Custom Overrides
		vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
		vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
		vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))

		-- Added Features
		vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse All"))
		vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
		vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))

		-- Unified Toggle Function
		local function toggle_dotfiles_and_gitignore()
			api.tree.toggle_hidden_filter()
			api.tree.toggle_gitignore_filter()
		end
		vim.keymap.set("n", "H", toggle_dotfiles_and_gitignore, opts("Toggle Dotfiles & Gitignored"))
	end

	-- 2. Setup Configuration
	require("nvim-tree").setup({
		on_attach = my_on_attach,
		hijack_cursor = true,

		update_focused_file = {
			enable = true,
			update_root = true,
		},

		view = {
			width = 35,
			relativenumber = true,
		},

		actions = {
			open_file = {
				quit_on_open = true,
			},
		},

		renderer = {
			group_empty = true,
			highlight_git = true,
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
			},
		},

		filters = {
			-- Set both to true so they hide together on startup.
			-- Pressing 'H' will now reveal both at the exact same time.
			dotfiles = true,
			git_ignored = true,
		},
	})

	-- 3. Last Window Auto-Close
	vim.api.nvim_create_autocmd("QuitPre", {
		callback = function()
			local tree_wins = {}
			local floating_wins = {}
			local wins = vim.api.nvim_list_wins()

			for _, w in ipairs(wins) do
				local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
				if bufname:match("NvimTree_") ~= nil then
					table.insert(tree_wins, w)
				end
				if vim.api.nvim_win_get_config(w).relative ~= "" then
					table.insert(floating_wins, w)
				end
			end

			if 1 == #wins - #floating_wins - #tree_wins then
				for _, w in ipairs(tree_wins) do
					vim.api.nvim_win_close(w, true)
				end
			end
		end,
	})
end

return M
