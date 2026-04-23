return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Native Neovim hook to turn on the engine for recognized file types
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
