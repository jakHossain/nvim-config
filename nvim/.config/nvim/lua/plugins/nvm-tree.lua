return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
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
    end

    -- 2. Setup Configuration
    require("nvim-tree").setup({
      on_attach = my_on_attach,
      hijack_cursor = true, -- Keeps cursor on the first letter of the name
      
      -- Auto-Sync Settings
      update_focused_file = {
        enable = true,
        update_root = true, -- Changes tree root if you switch projects
      },

      -- Visuals & Behavior
      view = {
        width = 35,
        relativenumber = true, -- Better for j/k jumping
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
        dotfiles = false, -- Set to true to hide files starting with '.'
      },

    })

  end,
}
