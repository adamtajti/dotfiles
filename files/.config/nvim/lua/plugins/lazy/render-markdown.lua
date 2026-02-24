return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  ft = { "markdown", "codecompanion" },
  opts = {
    heading = {
      left_pad = 0,
      left_margin = 0,
      atx = false,
    },
    bullet = {
      -- backup: "", "", "", " "
      -- options: 󰑀 , 󱘹 , 
      icons = { "" },
      ordered_icons = function(ctx)
        local value = vim.trim(ctx.value)
        local index = tonumber(value:sub(1, #value - 1))
        return ("%d."):format(index > 1 and index or ctx.index)
      end,
      left_pad = 0,
    },
    quote = {
      icon = "",
    },
    checkbox = {
      left_pad = 0,
      position = "overlay",
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'.
        icon = "󰄱 ",
        -- Highlight for the unchecked icon.
        highlight = "MoonflyGrey58",
        -- Highlight for item associated with unchecked checkbox.
        scope_highlight = nil,
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'.
        icon = "󰄲 ",
        -- Highlight for the checked icon.
        highlight = "MoonflyEmerald",
        -- Highlight for item associated with checked checkbox.
        scope_highlight = nil,
      },
      custom = {
        -- checked = {
        --   raw = "[x]",
        --   rendered = "󰄲",
        --   highlight = "RenderMarkdownChecked",
        -- },
        --
        -- this icon could be useful in the future: 󰄗
        --
        important = {
          raw = "[+]",
          rendered = "󰄱 ",
          highlight = "MoonflyKhaki",
        },
        inprogress = {
          raw = "[-]",
          rendered = "󰡖 ",
          highlight = "MoonflyBlue", -- Folded
        },
        trash = { raw = "[_]", rendered = "󱋬 ", highlight = "MoonflyOrchid" },
      },
    },
  },
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
