local M = {}

local HOME = os.getenv("HOME")
local sounds_folder = HOME .. "/.local/share/sounds/"

function M.play_sound(sound_file)
  -- Disabled sounds for now. It became a bit annoying under certain
  -- circumstances.
  -- vim.fn.jobstart(
  --   "paplay --volume 28000 '" .. sounds_folder .. sound_file .. "'"
  -- )
end

function M.setup()
  -- Other potential events to listen to:
  -- TextYankPost
  -- RecordingEnter
  -- RecordingLeave
  -- DirChanged
  -- BufWrite

  vim.api.nvim_create_autocmd("BufAdd", {
    callback = function() M.play_sound("tick_001.ogg") end,
  })
  vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(args)
      local bufnr = args.buf
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = bufnr })

      -- This sound shouldn't play when I switch from the oil buffer to an
      -- actual file
      if filetype == "oil" then
        return
      end

      M.play_sound("577442__birdofthenorth__paper-finger-nail.wav")
    end,
  })
  vim.api.nvim_create_autocmd("CursorMovedI", {
    callback = function() M.play_sound("click_001.ogg") end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function() M.play_sound("bong_001.ogg") end,
  })
end

return M
