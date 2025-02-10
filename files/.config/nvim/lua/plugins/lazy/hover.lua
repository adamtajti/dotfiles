local open_float = nil
local prev_expr = nil
local function eval(expr, args)
  local dap = require("dap")
  local nio = require("nio")
  local util = require("dapui.util")
  local dapui = require("dapui")
  nio.run(function()
    if not dap.session() then
      util.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    args = args or {}
    if not expr then
      expr = util.get_current_expr()
    end
    if open_float then
      if prev_expr == expr then
        open_float:jump_to()
        return
      else
        open_float:close()
      end
    end
    prev_expr = expr
    local elem = dapui.elements.hover
    elem.set_expression(expr, args.context)
    open_float =
      require("dapui.windows").open_float("hover", elem, args.position, args)
    if open_float then
      open_float:listen("close", function() open_float = nil end)
    end
  end)
end

return {
  "lewis6991/hover.nvim",
  event = "VeryLazy",
  dependencies = {
    -- nvim dap is required cause I made yet another customization so that selected word
    -- can be avaluated as an expression in the current debugging session (if any).
    -- That should take priority over anything else.
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    require("hover").setup({
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        -- require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.dap')
        -- require('hover.providers.fold_preview')
        -- require('hover.providers.diagnostic')
        -- require('hover.providers.man')
        -- require('hover.providers.dictionary')
      end,
      preview_opts = {
        border = "single",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    })

    -- Setup keymaps
    vim.keymap.set("n", "K", function(e)
      -- Case: DAP
      local dap = require("dap")
      local nio = require("nio")
      local bufnr = vim.api.nvim_win_get_buf(0)
      if dap.session() then
        -- dapui will evaluate the current word if nvim is in normal mode
        local lines = nio.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local width = 1
        for _, line in ipairs(lines) do
          width = math.max(width, vim.str_utfindex(line))
        end
        local height = #lines
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local position = {}
        position.line = (screen_h - height) / 3 * 2
        position.col = (screen_w - width) / 3 * 2
        eval(nil, {
          position = position,
        })
      end

      -- Case: Hover (default)
      require("hover").hover(e)
    end, { desc = "hover.nvim" })
    vim.keymap.set(
      "n",
      "gK",
      require("hover").hover_select,
      { desc = "hover.nvim (select)" }
    )
    vim.keymap.set(
      "n",
      "<C-p>",
      function() require("hover").hover_switch("previous") end,
      { desc = "hover.nvim (previous source)" }
    )
    vim.keymap.set(
      "n",
      "<C-n>",
      function() require("hover").hover_switch("next") end,
      { desc = "hover.nvim (next source)" }
    )

    -- Mouse support
    vim.keymap.set(
      "n",
      "<MouseMove>",
      require("hover").hover_mouse,
      { desc = "hover.nvim (mouse)" }
    )
    vim.o.mousemoveevent = true
  end,
}
