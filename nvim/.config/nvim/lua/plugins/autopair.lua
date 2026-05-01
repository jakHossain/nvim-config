return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp", -- Ensure cmp loads first so we can hook into it
  },
  config = function()
    local autopairs = require("nvim-autopairs")
    
    -- Initialize autopairs
    autopairs.setup({
      check_ts = true, -- Enable Treesitter integration if you use it
    })

    -- Wire it up to nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
  end,
}
