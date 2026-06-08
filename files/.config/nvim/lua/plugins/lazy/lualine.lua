---@type LazyPluginSpec
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()
    local function avante_context()
      local ctx = vim.g.avante_active_context or "personal"
      local icon = ctx == "work" and "󰚩 " or "󱚣 "
      return icon .. " " .. ctx
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = false,
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 3 } },
        lualine_c = {},
        lualine_x = {
          { "filetype", icon_only = true },
          "diff",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 3 } },
        lualine_c = {},
        lualine_x = { { "filetype", icon_only = true }, "diff" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          { avante_context, color = { fg = "#79dac8" } },
        },
        lualine_y = { "branch" },
        lualine_z = {},
      },

      -- I would like to use winbars so that I could see which files are open in the
      -- different windows at a glance. The problem is that it doesn't work nicely
      -- with the globalstatus. It keeps adding a new, empty line at the bottom of
      -- neovim when the windows are being switched.
      --
      -- winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { "filename" },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
      --
      -- inactive_winbar = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { "filename" },
      --   lualine_x = {},
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
    })
  end,
}
