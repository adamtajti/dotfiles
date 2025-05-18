---@type LazyPluginSpec
return {
  "DNLHC/glance.nvim",
  lazy = false,
  config = function()
    -- Lua configuration
    local glance = require("glance")
    local actions = glance.actions

    glance.setup({
      height = 18, -- Height of the window
      zindex = 45,

      -- When enabled, adds virtual lines behind the preview window to maintain context in the parent window
      -- Requires Neovim >= 0.10.0
      preserve_win_context = true,

      -- Controls whether the preview window is "embedded" within your parent window or floating
      -- above all windows.
      detached = function(winid)
        -- Automatically detach when parent window width < 100 columns
        return vim.api.nvim_win_get_width(winid) < 100
      end,
      -- Or use a fixed setting: detached = true,

      -- Configure preview window options
      preview_win_opts = {
        cursorline = true,
        number = true,
        wrap = true,
      },

      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = "―",
        bottom_char = "―",
      },

      list = {
        position = "right", -- Position of the list window 'left'|'right'
        width = 0.33, -- Width as percentage (0.1 to 0.5)
      },

      theme = {
        enable = true, -- Generate colors based on current colorscheme
        mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },

      mappings = {
        list = {
          ["j"] = actions.next, -- Next item
          ["k"] = actions.previous, -- Previous item
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          ["<Tab>"] = actions.next_location, -- Next location (skips groups, cycles)
          ["<S-Tab>"] = actions.previous_location, -- Previous location (skips groups, cycles)
          ["<C-u>"] = actions.preview_scroll_win(5), -- Scroll up the preview window
          ["<C-d>"] = actions.preview_scroll_win(-5), -- Scroll down the preview window
          ["v"] = actions.jump_vsplit, -- Open location in vertical split
          ["s"] = actions.jump_split, -- Open location in horizontal split
          ["t"] = actions.jump_tab, -- Open in new tab
          ["<CR>"] = actions.jump, -- Jump to location
          ["o"] = actions.jump,
          ["l"] = actions.open_fold,
          ["h"] = actions.close_fold,
          ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
          ["q"] = actions.close, -- Closes Glance window
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix, -- Send all locations to quickfix list
          -- ['<Esc>'] = false -- Disable a mapping
        },

        preview = {
          ["Q"] = actions.close,
          ["<Tab>"] = actions.next_location, -- Next location (skips groups, cycles)
          ["<S-Tab>"] = actions.previous_location, -- Previous location (skips groups, cycles)
          ["<leader>l"] = actions.enter_win("list"), -- Focus list window
        },
      },
      --
      -- hooks = {
      --   -- before_open = function(results, open, jump, method) open(results) end,
      --   -- before_close = function() end,
      --   -- after_close = function() end,
      -- }, -- Described in Hooks section

      folds = {
        fold_closed = "",
        fold_open = "",
        folded = true, -- Automatically fold list on startup
      },

      indent_lines = {
        enable = true, -- Show indent guidelines
        icon = "│",
      },

      winbar = {
        enable = true, -- Enable winbar for the preview (requires neovim-0.8+)
      },

      use_trouble_qf = false, -- Quickfix action will open trouble.nvim instead of built-in quickfix list
    })

    vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>")
    vim.keymap.set("n", "gR", "<CMD>Glance references<CR>")
    vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>")
    vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>")
  end,
}
