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
  -- disabled lazy mode to be able to script some scenarios more easily
  lazy = false,
  -- event = "VeryLazy",
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

    -- Ripped from which-key
    generateNotificationKeybind("r", "Registers", function()
      local items = {} ---@type wk.Plugin.item[]

      local is_osc52 = vim.g.clipboard and vim.g.clipboard.name == "OSC 52"
      local has_clipboard = vim.g.loaded_clipboard_provider == 2

      local registers = '*+"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'
      local labels = {
        ['"'] = "last deleted, changed, or yanked content",
        ["0"] = "last yank",
        ["-"] = "deleted or changed content smaller than one line",
        ["."] = "last inserted text",
        ["%"] = "name of the current file",
        [":"] = "most recent executed command",
        ["#"] = "alternate buffer",
        ["="] = "result of an expression",
        ["+"] = "synchronized with the system clipboard",
        ["*"] = "synchronized with the selection clipboard",
        ["_"] = "black hole",
        ["/"] = "last search pattern",
      }
      local replace = {
        ["<Space>"] = " ",
        ["<lt>"] = "<",
        ["<NL>"] = "\n",
        ["\r"] = "",
      }
      for i = 1, #registers, 1 do
        local key = registers:sub(i, i)
        local value = ""
        if is_osc52 and key:match("[%+%*]") then
          value =
            "OSC 52 detected, register not checked to maintain compatibility"
        elseif has_clipboard or not key:match("[%+%*]") then
          local ok, reg_value = pcall(vim.fn.getreg, key, 1)
          value = (ok and reg_value or "") --[[@as string]]
        end
        if value ~= "" then
          value = vim.fn.keytrans(value) --[[@as string]]
          for k, v in pairs(replace) do
            value = value:gsub(k, v) --[[@as string]]
          end
          table.insert(
            items,
            { key = key, desc = labels[key] or "", value = value }
          )
        end
      end
      return vim.inspect(items)
    end),
    generateNotificationKeybind("e", "Extmarks", function()
      local extmarks = vim.api.nvim_buf_get_extmarks(
        0, -- Buffer handle
        -1, -- Namespace ID (nil = all namespaces)
        0, -- Start line (0-based, first line)
        -1, -- End line (-1 = last line)
        { details = true } -- Include metadata (e.g., ns_id)
      )

      return vim.inspect({
        explanation = "{ ID, 0index_row, 0index_col, {DETAILS_OBJ}}",
        extmarks = extmarks,
      })
    end),
  },
}
