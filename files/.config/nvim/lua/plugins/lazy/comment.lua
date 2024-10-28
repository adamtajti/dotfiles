--- Comments out sections of code temporary
--- https://github.com/numToStr/Comment.nvim
return {
  "numToStr/Comment.nvim",
  event = "BufEnter",
  opts = {
    toggler = {
      line = "gcc",
    },
    mappings = {
      basic = true,
      extra = true,
    },
  },
}
