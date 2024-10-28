local function get_repo_root()
  local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end
  local open_pop = assert(io.popen("git rev-parse --show-toplevel", "r"))
  return trim(open_pop:read("*all"))
end

return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar" },
  event = { "VeryLazy" },
  config = true,
  keys = {
    {
      "<leader>gsr",
      mode = { "n" },
      function()
        require("grug-far").open({})
        vim.cmd("lcd " .. get_repo_root())
      end,
      desc = "Replace",
      noremap = true,
    },
    {
      "<leader>csr",
      mode = { "n" },
      function() require("grug-far").open({}) end,
      desc = "Replace",
      noremap = true,
    },
    {
      "<leader>gsr",
      mode = { "v" },
      function()
        require("grug-far").with_visual_selection({})
        vim.cmd("lcd " .. get_repo_root())
      end,
      desc = "Replace",
      noremap = true,
    },
    {
      "<leader>csr",
      mode = { "v" },
      function() require("grug-far").with_visual_selection({}) end,
      desc = "Replace",
      noremap = true,
    },
  },
}
