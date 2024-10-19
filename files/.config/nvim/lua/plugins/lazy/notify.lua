return {
  "rcarriga/nvim-notify",
  branch = "master",
  name = "notify",
  event = "VeryLazy",
  opts = {
    stages = "static",
    top_down = true,
    timeout = 5000,
    render = "wrapped-compact",
  },
  config = function(_, lazy_opts)
    require("notify").setup(lazy_opts)
  end,
}
