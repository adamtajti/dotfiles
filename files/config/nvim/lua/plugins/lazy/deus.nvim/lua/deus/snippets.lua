local utils = require("deus.utils")

local M = {}

function M.selection_to_snippet(id, description, stringArray)
	-- Open the file in write mode
	local file, err = io.open("/home/adamtajti/GitHub/dotfiles/files/snippets/vscode/snippets/all.json", "w")

	if not file then
		error("Error opening file: " .. err)
	end

	local fileContents = file:read("*a")

	local snippetsTable = vim.json.decode(fileContents)

	snippetsTable[id] = {
		prefix = id,
		body = stringArray,
		description = description,
	}

	file:seek("set")

	-- Write the JSON data to the file
	file:write(vim.json.encode(snippetsTable))

	-- Close the file
	file:close()
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
		desc = "Save Snippet",
		noremap = true,
		silent = true,
		callback = function()
			local lines = utils.get_visual_selection()

			local Popup = require("nui.popup")
			local event = require("nui.utils.autocmd").event

			local popup = Popup({
				enter = true,
				focusable = true,
				border = {
					style = "rounded",
				},
				position = "50%",
				size = {
					width = "80%",
					height = "60%",
				},
			})

			-- mount/open the component
			popup:mount()

			-- unmount component when cursor leaves buffer
			popup:on(event.BufLeave, function()
				popup:unmount()
			end)

			-- set content
			local content = utils.ensure_string_array(lines)
			vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, content)

			M.selection_to_snippet("first-snippet-test-without-id", "First Snippet Test Without ID", content)
		end,
	})
end

return M
