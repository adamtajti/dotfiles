local lazy_plugin_config = require("plugins.config")

return {
  "obsidian-nvim/obsidian.nvim",
  -- dir = "~/GitHub/adamtajti/obsidian.nvim",
  -- dev = true,
  -- version = "*", -- recommended, use latest release instead of latest commit
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Dropbox/Notebook/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Dropbox/Notebook/*.md",
  },
  cmd = {
    "ObsidianBacklinks",
    "ObsidianCheck",
    "ObsidianDailies",
    "ObsidianDebug",
    "ObsidianExtractNote",
    "ObsidianFollowLink",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianLinks",
    "ObsidianNew",
    "ObsidianNewFromTemplate",
    "ObsidianOpen",
    "ObsidianPasteImg",
    "ObsidianQuickSwitch",
    "ObsidianRename",
    "ObsidianSearch",
    "ObsidianTOC",
    "ObsidianTags",
    "ObsidianTemplate",
    "ObsidianToday",
    "ObsidianToggleCheckbox",
    "ObsidianTomorrow",
    "ObsidianWorkspace",
    "ObsidianYesterday",
  },

  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre "
  --     .. vim.fn.expand("~")
  --     .. "/Dropbox/Notebook/*.md",
  --   "BufNewFile " .. vim.fn.expand("~") .. "/Dropbox/Notebook/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- To add Obsidian as a provider Blink
    "saghen/blink.cmp",
  },
  opts = {
    workspaces = {
      {
        name = "notebook",
        path = vim.fn.expand("~") .. "/Dropbox/Notebook/",
      },
    },
    completion = {
      nvim_cmp = lazy_plugin_config.blink_instead_of_cmp == false,
      blink = lazy_plugin_config.blink_instead_of_cmp,
      min_chars = 0,
    },

    notes_subdir = "drafts",

    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "notes_subdir",

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "markdown",

    -- Optional, boolean or a function that takes a filename and returns a boolean.
    -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = true,

    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "assets/", -- This is the default

      -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
      ---@return string
      img_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end,

      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },

    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      enable = false, -- set to false to disable all additional syntax features
    },
  },
}
