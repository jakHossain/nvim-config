-- lua/plugins/theme.lua
-- return {
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000, -- Make sure to load this before all the other start plugins
--     config = function()
--       vim.cmd.colorscheme("catppuccin")
--     end,
--   },
-- }
-- return {
--   "rebelot/kanagawa.nvim",
--   lazy = false,    -- load at startup since it's your colorscheme
--   priority = 1000, -- load before other plugins
--   opts = {
--     -- your kanagawa options here (all optional)
--     -- theme = "wave",  -- "wave" | "dragon" | "lotus"
--     -- transparent = false,
--   },
--   config = function(_, opts)
--     require("kanagawa").setup(opts)
--     vim.cmd.colorscheme("kanagawa")
--   end,
-- }
return {
    "tiagovla/tokyodark.nvim",
    opts = {
      transparent_background = true
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
}
