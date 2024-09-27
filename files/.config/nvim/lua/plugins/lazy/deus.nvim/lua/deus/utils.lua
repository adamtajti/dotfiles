local M = {}

function M.copy_to_clipboard(str)
	-- vim.api.nvim_command("let @+ = '" .. str .. "'")
	vim.fn.setreg("+", str)
end

function M.split_string_to_lines(str)
	local lines = {}
	for line in str:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	return lines
end

function M.ensure_string_array(var)
	if type(var) == "string" then
		return M.split_string_to_lines(var)
	elseif type(var) == "table" then
		-- Check if it's already a string array
		for _, value in ipairs(var) do
			if type(value) ~= "string" then
				error("Array contains non-string elements")
			end
		end
		return var -- Return the string array as is
	else
		error("Invalid type")
	end
end

--- Returns the visually selected text.
---
--- @return string
function M.get_visual_selection()
	-- Yank current visual selection into the 'v' register
	--
	-- Note that this makes no effort to preserve this register
	vim.cmd('noau normal! "vy"')

	return vim.fn.getreg("v")
end

--- Gets the overall width of the whole NVIM UI.
---
--- @return integer
function M.get_nvim_width()
	return vim.api.nvim_get_option("columns")
end

--- Gets the overall height of the whole NVIM UI.
---
--- @return integer
function M.get_nvim_height()
	return vim.api.nvim_get_option("lines")
end

return M
