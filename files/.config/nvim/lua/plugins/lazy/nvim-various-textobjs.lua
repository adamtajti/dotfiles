local function setupIndentationKeymaps()
  vim.keymap.set("n", "dsi", function()
    -- select outer indentation
    require("various-textobjs").indentation("outer", "outer")

    -- plugin only switches to visual mode when a textobj has been found
    local indentationFound = vim.fn.mode():find("V")
    if not indentationFound then
      return
    end

    -- dedent indentation
    vim.cmd.normal({ "<", bang = true })

    -- delete surrounding lines
    local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
    local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
    vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
    vim.cmd(tostring(startBorderLn) .. " delete")
  end, { desc = "Delete Surrounding Indentation" })

  vim.keymap.set("n", "ysii", function()
    local startPos = vim.api.nvim_win_get_cursor(0)

    -- identify start- and end-border
    require("various-textobjs").indentation("outer", "outer")
    local indentationFound = vim.fn.mode():find("V")
    if not indentationFound then
      return
    end
    vim.cmd.normal({ "V", bang = true }) -- leave visual mode so the `'<` `'>` marks are set

    -- copy them into the + register
    local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
    local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
    local startLine =
      vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
    local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
    vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")

    -- highlight yanked text
    local ns = vim.api.nvim_create_namespace("ysi")
    vim.highlight.range(0, ns, "IncSearch", { startLn, 0 }, { startLn, -1 })
    vim.highlight.range(0, ns, "IncSearch", { endLn, 0 }, { endLn, -1 })
    vim.defer_fn(
      function() vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) end,
      1000
    )

    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, startPos)
  end, { desc = "Yank surrounding indentation" })
end

local function openURL(url)
  local opener
  if vim.fn.has("macunix") == 1 then
    opener = "open"
  elseif vim.fn.has("linux") == 1 then
    opener = "xdg-open"
  elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    opener = "start"
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

--- source: https://github.com/chrisgrieser/nvim-various-textobjs
--- comment: I may want to disable this, or at least it should be disabled in oil.
local function setupBetterUrlFinder()
  vim.keymap.set("n", "gx", function()
    print("Better URL Finder running...")
    require("various-textobjs").url()
    local foundURL = vim.fn.mode():find("v")
    if foundURL then
      vim.cmd.normal('"zy')
      local url = vim.fn.getreg("z")
      openURL(url)
    else
      -- find all URLs in buffer
      local urlPattern =
        require("various-textobjs.charwise-textobjs").urlPattern
      local bufText =
        table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
      local urls = {}
      for url in bufText:gmatch(urlPattern) do
        table.insert(urls, url)
      end
      if #urls == 0 then
        return
      end

      -- select one, use a plugin like dressing.nvim for nicer UI for
      -- `vim.ui.select`
      vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
        if choice then
          openURL(choice)
        end
      end)
    end
  end, { desc = "URL Opener" })
end

return {
  "chrisgrieser/nvim-various-textobjs",
  lazy = false,
  opts = function()
    require("various-textobjs").setup({
      useDefaultKeymaps = true,
      disabledKeymaps = { "gc" },
    })

    setupIndentationKeymaps()
    setupBetterUrlFinder()
  end,
}
