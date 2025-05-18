local notebook_path = os.getenv("NOTEBOOK_PATH")

local function generateNotificationKeybind(keybind, title, text_fn)
  return {
    "<Leader>N" .. keybind,
    function()
      vim.notify(text_fn(), vim.log.levels.INFO, {
        title = title .. " - deus.nvim",
        timeout = 10000,
      })
    end,
    desc = title,
    noremap = true,
  }
end

---@type LazyPluginSpec
return {
  "adamtajti/deus.nvim",
  dev = true,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    "grapp-dev/nui-components.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function() require("deus").setup({}) end,
  keys = {
    {
      "<leader>nsf",
      function()
        require("telescope.builtin").find_files({
          cwd = notebook_path,
          hidden = true,
        })
      end,
      desc = "Find Files (Notebook)",
      noremap = true,
    },
    {
      "<Leader>nst",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          hidden = true,
          search_dirs = {
            notebook_path,
          },
        })
      end,
      desc = "Search Text (Notebook)",
      noremap = true,
    },
    {
      "<Leader>nso",
      function()
        require("telescope").extensions["recent-files"].recent_files({
          cwd = notebook_path,
        })
      end,
      desc = "Previously Opened Files",
      noremap = true,
    },
    generateNotificationKeybind(
      "m",
      "Current mode",
      function() return vim.api.nvim_get_mode().mode end
    ),
    generateNotificationKeybind(
      "bpa",
      "Absolute path to the current buffer",
      function() return vim.fn.expand("%:p") end
    ),
    generateNotificationKeybind(
      "bpr",
      "Relative path to the current buffer",
      function() return vim.fn.expand("%") end
    ),
    generateNotificationKeybind(
      "cwd",
      "Current working directory",
      function() return vim.fn.getcwd() end
    ),
    generateNotificationKeybind("N", "Named Namespaces", function()
      local namespaces = vim.api.nvim_get_namespaces()
      return vim.inspect({
        namespaces = namespaces,
      })
    end),
    generateNotificationKeybind(
      "wnw",
      "Window: numberwidth",
      function() return vim.inspect(vim.wo[0].numberwidth) end
    ),
    generateNotificationKeybind("e", "Extmarks", function()
      local extmarks = vim.api.nvim_buf_get_extmarks(
        0, -- Buffer handle
        -1, -- Namespace ID (nil = all namespaces)
        0, -- Start line (0-based, first line)
        -1, -- End line (-1 = last line)
        { details = true } -- Include metadata (e.g., ns_id)
      )

      return vim.inspect({
        extmarks = extmarks,
      })
    end),
  },
}
