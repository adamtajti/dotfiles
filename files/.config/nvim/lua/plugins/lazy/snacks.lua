-- https://github.com/folke/snacks.nvim
return {
  "folke/snacks.nvim",
  -- "adamtajti/snacks.nvim",
  -- dev = true,
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = {
      enabled = true,
      size = 10 * 1024 * 1024, -- 10MB
      line_length = 14000,
    },
    dashboard = { enabled = false },
    explorer = { enabled = false },

    -- Guidelines on the left to see which indentation I'm currently on
    -- I used indent-blankline before, archived that config
    -- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
      chunk = {
        enabled = false,
      },
    },
    input = { enabled = true },

    -- Image viewer
    -- Disabled for now as it's not compatible with Obsidian yet and I can't disable the error notifications
    -- https://github.com/folke/snacks.nvim/blob/main/docs/image.md
    image = { enabled = false },

    -- Telescope alternative?
    picker = { enabled = true },

    -- An alternative to notify
    -- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
    notifier = {
      enabled = true,
      top_down = true,
      margin = { top = 3, right = 1, bottom = 3 },
      timeout = 1500,
      style = "minimal",
      -- level = vim.log.levels.WARN,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = "󰊠 ",
      },
    },

    -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
    -- https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
    quickfile = { enabled = true },

    scope = { enabled = true },

    -- Smooth scrolling for Neovim. Properly handles scrolloff and mouse scrolling.
    -- I disabled it, as it kind of feels awkwards sometimes
    -- https://github.com/folke/snacks.nvim/blob/main/docs/scroll.md
    scroll = { enabled = false },

    -- Pretty status column
    -- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = true, -- show open fold icons
        git_hl = true, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },

    -- Auto-show LSP references and quickly navigate between them
    -- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
    words = { enabled = true },

    styles = {
      notification_history = {
        -- relative = "editor",
        border = "rounded",
        -- zindex = 100,
        -- width = 0.99,
        -- height = 0.99,
        max_height = 10,
        minimal = false,
        title = " Notification History ",
        resize = false,
        title_pos = "center",
        position = "top",
        ft = "markdown",
        bo = { filetype = "snacks_notif_history", modifiable = false },
        wo = { winhighlight = "Normal:SnacksNotifierHistory" },
        keys = { q = "close" },
        -- win = {
        -- 	split = {
        -- 	}
        -- }
      },
    },
  },
  keys = {
    {
      "<leader>ss",
      function() require("snacks").picker.lsp_symbols() end,
      desc = "LSP Symbols",
      noremap = true,
    },
    {
      "<leader>sS",
      function()
        require("snacks").picker.lsp_workspace_symbols({
          workspace = true,
          tree = true,
          supports_live = true,
          live = true,
        })
      end,
      desc = "LSP Workspace Symbols",
      noremap = true,
    },
  },
}
