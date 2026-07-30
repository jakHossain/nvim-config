-- lua/keymaps.lua
local keymap = vim.keymap.set

------------------------------------------------------------------
-- General
------------------------------------------------------------------
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })
keymap("n", "<Esc>", ":nohlsearch<CR><Esc>", { desc = "Clear search highlights and escape" })

------------------------------------------------------------------
-- Telescope
------------------------------------------------------------------
-- Standard searches (Respects .gitignore)
keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })

keymap("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

keymap("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

keymap("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Help tags" })

keymap("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Search current file" })

-- Search ALL files (Bypasses .gitignore)
keymap("n", "<leader>FF", function()
	require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
end, { desc = "Find ALL files" })

keymap("n", "<leader>FG", function()
	require("telescope.builtin").live_grep({ no_ignore = true, hidden = true })
end, { desc = "Live grep ALL files" })

-- Resume Search
keymap("n", "<leader>fr", function()
	require("telescope.builtin").resume()
end, { desc = "Resume last search" })

------------------------------------------------------------------
-- Nvim-tree
------------------------------------------------------------------
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", { desc = "Find current file in Tree" })

------------------------------------------------------------------
-- Svelte LSP
------------------------------------------------------------------
keymap("n", "<leader>rr", function()
	local clients = vim.lsp.get_clients({ name = "svelte" })
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id, true)
	end
	vim.cmd("edit")
	print("Svelte LSP restarted")
end, { desc = "Restart Svelte LSP" })

------------------------------------------------------------------
-- LSP Buffer Keymaps & Completion
------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local client_id = ev.data.client_id

		-- Helper function to easily apply buffer-local keymaps with descriptions
		local function buf_map(mode, lhs, rhs, desc)
			keymap(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end

		-- Navigation & Diagnostics
		buf_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
		buf_map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
		buf_map("n", "K", vim.lsp.buf.hover, "Hover documentation")
		buf_map("n", "gr", vim.lsp.buf.references, "Find references")
		buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		buf_map("n", "gl", vim.diagnostic.open_float, "Open line diagnostics")

		-- Refactoring & Workspace Actions
		buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
		buf_map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
		buf_map("n", "<leader>dw", vim.diagnostic.setqflist, "Workspace diagnostics list")
		buf_map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")

		-- Native Completion Enablement
		vim.lsp.completion.enable(true, client_id, ev.buf, { autotrigger = false })
		keymap("i", "<C-Space>", "<C-x><C-o>", { buffer = ev.buf, desc = "Trigger completion" })
	end,
})
