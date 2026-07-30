local keymap = vim.keymap.set

------------------------------------------------------------------
-- General
------------------------------------------------------------------
keymap("n", "<leader>q", ":q<CR>")
keymap("i", "jk", "<Esc>")
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>wq", ":wq<CR>")

------------------------------------------------------------------
-- Telescope
------------------------------------------------------------------
keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Telescope find files" })
keymap("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Telescope live grep" })
keymap("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Telescope buffers" })
keymap("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Telescope help tags" })
keymap("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Search current file" })

------------------------------------------------------------------
-- Nvim-tree
------------------------------------------------------------------
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", { desc = "Find current file in Tree" })

------------------------------------------------------------------
-- Svelte LSP
------------------------------------------------------------------

------------------------------------------------------------------
-- LSP Buffer Keymaps & Completion
------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local client_id = ev.data.client_id

		-- Navigation & Diagnostics
		keymap("n", "gd", vim.lsp.buf.definition, opts)
		keymap("n", "K", vim.lsp.buf.hover, opts)
		keymap("n", "gr", vim.lsp.buf.references, opts)
		keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap("n", "gl", vim.diagnostic.open_float, opts)

		-- Native Completion Enablement
		vim.lsp.completion.enable(true, client_id, ev.buf, { autotrigger = false })
		keymap("i", "<C-Space>", "<C-x><C-o>", opts)
	end,
})
