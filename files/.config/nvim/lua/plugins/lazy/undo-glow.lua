return {
  "y3owk1n/undo-glow.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    animation = {
      enabled = true,
      duration = 240,
      animation_type = "zoom",
      window_scoped = true,
    },
    highlights = {
      undo = {
        hl_color = { bg = "#693232" },
      },
      redo = {
        hl_color = { bg = "#2F4640" },
      },
      yank = {
        hl_color = { bg = "#7A683A" },
      },
      paste = {
        hl_color = { bg = "#4d5d8d" },
      },
      search = {
        hl_color = { bg = "#5C475C" },
      },
      comment = {
        hl_color = { bg = "#7A5A3D" },
      },
      cursor = {
        hl_color = { bg = "#373c4d" },
      },
    },
    priority = 2048 * 3,
  },
  keys = {
    {
      "u",
      function() require("undo-glow").undo() end,
      mode = "n",
      desc = "Undo with highlight",
      noremap = true,
    },
    {
      "U",
      function() require("undo-glow").redo() end,
      mode = "n",
      desc = "Redo with highlight",
      noremap = true,
    },
    {
      "p",
      function() require("undo-glow").paste_below() end,
      mode = "n",
      desc = "Paste below with highlight",
      noremap = true,
    },
    {
      "P",
      function() require("undo-glow").paste_above() end,
      mode = "n",
      desc = "Paste above with highlight",
      noremap = true,
    },
    {
      "n",
      function()
        require("undo-glow").search_next({
          animation = {
            animation_type = "strobe",
          },
        })
      end,
      mode = "n",
      desc = "Search next with highlight",
      noremap = true,
    },
    {
      "N",
      function()
        require("undo-glow").search_prev({
          animation = {
            animation_type = "strobe",
          },
        })
      end,
      mode = "n",
      desc = "Search prev with highlight",
      noremap = true,
    },
    {
      "*",
      function()
        require("undo-glow").search_star({
          animation = {
            animation_type = "strobe",
          },
        })
      end,
      mode = "n",
      desc = "Search star with highlight",
      noremap = true,
    },
    {
      "gc",
      function()
        -- This is an implementation to preserve the cursor position
        local pos = vim.fn.getpos(".")
        vim.schedule(function() vim.fn.setpos(".", pos) end)
        return require("undo-glow").comment()
      end,
      mode = { "n", "x" },
      desc = "Toggle comment with highlight",
      expr = true,
      noremap = true,
    },
    {
      "gc",
      function() require("undo-glow").comment_textobject() end,
      mode = "o",
      desc = "Comment textobject with highlight",
      noremap = true,
    },
    {
      "gcc",
      function() return require("undo-glow").comment_line() end,
      mode = "n",
      desc = "Toggle comment line with highlight",
      expr = true,
      noremap = true,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight when yanking (copying) text",
      callback = function() require("undo-glow").yank() end,
    })

    -- This only handles neovim instance and do not highlight when switching panes in tmux
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "Highlight when cursor moved significantly",
      callback = function()
        require("undo-glow").cursor_moved({
          animation = {
            animation_type = "slide",
          },
        })
      end,
    })

    -- This will handle highlights when focus gained, including switching panes in tmux
    vim.api.nvim_create_autocmd("FocusGained", {
      desc = "Highlight when focus gained",
      callback = function()
        ---@type UndoGlow.CommandOpts
        local opts = {
          animation = {
            animation_type = "slide",
          },
        }

        opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
        local current_row = vim.api.nvim_win_get_cursor(0)[1]
        local cur_line = vim.api.nvim_get_current_line()
        require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
          s_row = current_row - 1,
          s_col = 0,
          e_row = current_row - 1,
          e_col = #cur_line,
          force_edge = opts.force_edge == nil and true or opts.force_edge,
        }))
      end,
    })

    -- vim.api.nvim_create_autocmd("CmdLineLeave", {
    --   pattern = { "/", "?" },
    --   desc = "Highlight when search cmdline leave",
    --   callback = function()
    --     require("undo-glow").search_cmd({
    --       animation = {
    --         animation_type = "fade",
    --       },
    --     })
    --   end,
    -- })
  end,
}
