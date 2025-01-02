-- Archived:
--
-- Can't filter down to the actually executed pipelines. It just lists all of
-- them, while it's quite common to have experimental pipelines that are not
-- used at all, or rarely (so they should be unrelated to the current PR/branch)
--
-- No visual feedback while the pipelines are being fetched
--
-- Annoying installation process: The rust compilation takes a while and the end
-- result can signal a failure, while the plugin works just fine.
return {
  "topaxi/pipeline.nvim",
  keys = {
    { "<leader>ci", "<cmd>Pipeline<cr>", desc = "Open pipeline.nvim" },
  },
  -- optional, you can also install and use `yq` instead.
  build = "make",
  ---@type pipeline.Config
  opts = {},
}
