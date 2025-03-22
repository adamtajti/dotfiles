-- Enables the use of Stencil templates.
-- TODO: I didn't configure this one yet, but it seemed promising for common tasks, where some
-- lua scripting may actually help for templating.
return {
  "yebt/stencil.nvim",
  enabled = false,
  cmd = { "Stencil" },
  config = function()
    require("stncl").setup({
      -- Your configuration here
    })
  end,
}
