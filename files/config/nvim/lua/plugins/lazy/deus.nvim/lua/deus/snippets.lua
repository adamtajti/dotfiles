local utils = require("deus.utils")

local M = {}

function M.snippet_to_file(ft, snippet)
	-- Open the file in write mode
	-- TODO: Filetype should be automatically detected, but it should also be modifyiable
	-- TODO: Even if the filetype is known, this snippet may be for work, in which case a different file shall be chosen. e.g. "tulip". This should be an option on the UI. custom_file
	local file, err = io.open("/home/adamtajti/GitHub/dotfiles/files/snippets/luasnippets/lua/lua.lua", "w")

	if not file then
		error("Error opening file: " .. err)
	end

	local file_contents = file:read("*a")
	file:close()
end

function M.selection_to_snippet(id, description, string_array)
	-- Initialize the start of the snippet
	local snippet = "s('p-" .. id .. "', {\n"

	-- Add nodes to the snippet
	for _, entry in ipairs(string_array) do
		local escaped_entry = entry:gsub('"', '\\"')
		snippet = snippet .. '\tt({"' .. escaped_entry .. '", ""}),\n'
	end

	-- Close off the snippet
	snippet = snippet .. "}),"
	return snippet
end

function M.setup()
	vim.api.nvim_set_keymap("n", "<Leader>Di", "", {
		noremap = true,
		desc = "Install: Creates folders and link files as per OS",
		callback = function()
			-- TODO: Use the same solution as the update script does with a function
			vim.cmd("!~/GitHub/dotfiles/install.sh")
		end,
	})

	vim.api.nvim_set_keymap("n", "<Leader>Du", "", {
		noremap = true,
		desc = "Update the System (cross-platform shell scripts)",
		callback = function()
			local buffer_handle = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_open_win(
				buffer_handle,
				true,
				-- TODO: Set this to around 90-100% of the editor size with https://github.com/nvim-lua/plenary.nvim
				{
					relative = "editor",
					row = 1,
					col = 1,
					width = 100,
					height = 32,
					border = "rounded",
					style = "minimal",
				}
			)
			local term_chan = vim.api.nvim_open_term(buffer_handle, {})
			local home_dir = os.getenv("HOME")
			vim.fn.jobstart(home_dir .. "/GitHub/dotfiles/installers/_update-system.sh", {
				cwd = home_dir .. "/GitHub/dotfiles/installers/",
				on_stdout = function(_, data)
					vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
				end,
				on_stderr = function(_, data)
					vim.api.nvim_chan_send(term_chan, table.concat(data, "\r\n"))
				end,
				on_exit = function(_, exit_code)
					vim.fn.chanclose(term_chan)

					if exit_code == 0 then
						require("notify")("dotfiles: successful update!")
					end
					-- TODO: close the window on success
				end,
			})
		end,
	})

	vim.api.nvim_set_keymap("n", "<Leader>Dl", "", {
		desc = "Dotfiles: Update Links",
		noremap = true,
		silent = true,
		callback = function()
			print("TODO: Reimplement that installation script, find where it was deleted")
		end,
	})

	vim.api.nvim_set_keymap("v", "<Leader>Ss", "", {
		desc = "Copy to Clipboard as a Lua Snippet",
		noremap = true,
		silent = true,
		callback = function()
			-- Get content from visual selection
			local lines = utils.get_visual_selection()
			local content = utils.ensure_string_array(lines)

			local snippet =
				M.selection_to_snippet("first-snippet-test-without-id", "First Snippet Test Without ID", content)
			utils.copy_to_clipboard(snippet)
		end,
	})
end

return M
