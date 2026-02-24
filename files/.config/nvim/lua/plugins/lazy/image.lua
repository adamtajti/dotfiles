---@type LazyPluginSpec
return {
  "3rd/image.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {
    backend = "sixel",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = true,
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = true,
      },
      html = {
        enabled = false, -- buggy
        filetypes = { "markdown" },
      },
    },
    max_height_window_percentage = 70,
  },
}
