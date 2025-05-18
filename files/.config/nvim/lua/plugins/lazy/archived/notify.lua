local level = vim.log.levels.INFO

if vim.fn.has_key(vim.fn.environ(), "NVIM_NOTIFY_DEBUG_MODE") == 1 then
  level = vim.log.levels.DEBUG
end

return {
  "rcarriga/nvim-notify",
  branch = "master",
  -- name = "notify",
  lazy = false,
  priority = 2000,
  -- event = "VeryLazy",
  opts = {
    background_colour = "#000000",
    -- stages = "static",
    -- top_down = true,
    timeout = 2000,
    fps = 144,
    level,
    render = "wrapped-compact",
  },
  config = function(_, lazy_opts)
    require("notify").setup(lazy_opts)
    vim.notify = require("notify")
  end,
}
