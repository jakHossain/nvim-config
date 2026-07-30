return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- Connects cmp to your language servers
    "L3MON4D3/LuaSnip",         -- Snippet engine (required by cmp)
    "saadparwaiz1/cmp_luasnip", -- Connects luasnip to cmp
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      experimental = {
        ghost_text = true
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        -- Trigger the menu manually
        ["<C-Space>"] = cmp.mapping.complete(),
        -- Confirm the selection with Enter
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- Prioritize LSP suggestions (types, methods)
        { name = "luasnip" },  -- Then snippets
        { name = 'nvim_lsp_signature_help' }, -- Add this line
      })
    })
  end,
}
