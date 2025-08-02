local tulip = require("work.tulip")

---@type LazyPluginSpec
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  enabled = false,
  -- build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    should_attach = function(_, bufname)
      -- Enable for tulip projects
      if tulip.copilot.should_attach(bufname) then
        return true
      end

      -- the default should be not to attach at all
      return false
    end,
    panel = {
      enabled = false,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = false,
      auto_trigger = false,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = "<C-J>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      json = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      -- ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 18.x
    server_opts_overrides = {},
  },
}
