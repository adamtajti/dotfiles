local M = {}

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "neo-tree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
}

local get_filename = function()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if filename ~= nil and filename ~= "" then
    local file_icon, file_icon_color =
      require("nvim-web-devicons").get_icon_color(
        filename,
        extension,
        { default = true }
      )

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if file_icon == nil or file_icon == "" then
      file_icon = ""
      file_icon_color = ""
    end

    return " "
      .. "%#"
      .. hl_group
      .. "#"
      .. file_icon
      .. "%*"
      .. " "
      .. "%#LineNr#"
      .. filename
      .. "%*"
  end
end

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

M.get_winbar = function()
  if excludes() then
    print("get_winbar excludes")
    return
  end
  print("get_winbar include")
  local value = get_filename()

  if value ~= nil and value ~= "" then
    value = value .. " "
  end

  local status_ok, _ =
    pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

vim.api.nvim_create_autocmd({
  "CursorMoved",
  "BufWinEnter",
  "BufFilePost",
  "InsertEnter",
  "BufWritePost",
}, {
  callback = function()
    -- TODO: Get this working
    --M.get_winbar()
  end,
})
