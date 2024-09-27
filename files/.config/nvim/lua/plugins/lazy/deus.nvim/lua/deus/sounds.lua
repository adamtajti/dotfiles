local M = {}

local HOME = os.getenv("HOME")
local sounds_folder = HOME .. "/.local/share/sounds/"

function M.play_sound(sound_file)
	vim.fn.jobstart("paplay --volume 28000 '" .. sounds_folder .. sound_file .. "'")
end

function M.setup()
	-- Other potential events to listen to:
	-- TextYankPost
	-- RecordingEnter
	-- RecordingLeave
	-- DirChanged
	-- BufWrite

	vim.api.nvim_create_autocmd("BufAdd", {
		callback = function()
			M.play_sound("tick_001.ogg")
		end,
	})
	vim.api.nvim_create_autocmd("BufDelete", {
		callback = function()
			M.play_sound("577442__birdofthenorth__paper-finger-nail.wav")
		end,
	})
	vim.api.nvim_create_autocmd("CursorMovedI", {
		callback = function()
			M.play_sound("click_001.ogg")
		end,
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			M.play_sound("bong_001.ogg")
		end,
	})
end

return M
