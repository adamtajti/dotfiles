--- Preview Markdown in your modern browser with synchronised scrolling and flexible configuration.
--- https://github.com/iamcco/markdown-preview.nvim
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
  keys = {
    {
      "<Leader>b.p",
      ":MarkdownPreview<CR>",
      ft = "markdown",
      desc = "Preview in Browser",
    },
  },
}
