local StartedWithStdin = false
local EnableAutoSession = false
local SessionName = ""

local function buffer_filter(bufnr)
	local buftype = vim.bo[bufnr].buftype
	if buftype == "help" then
		return true
	end
	-- if buftype == "oil" then
	-- 	return false
	-- end
	if buftype ~= "" and buftype ~= "acwrite" then
		return false
	end
	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return false
	end
	return vim.bo[bufnr].buflisted
end

local function session_name_from_path(dir)
	-- For windows, have to check for both as either could be used
	if vim.fn.has("win32") == 1 then
		dir = dir:gsub("\\", "_")
	end

	return (dir:gsub("/", "_"))
end

return {
	"stevearc/resession.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- To load gitsigns over the restored buffers
	},
	lazy = false,
	opts = {
		default_buf_filter = buffer_filter,
	},
	config = function(_, opts)
		local resession = require("resession")
		resession.setup(opts)

		vim.api.nvim_create_autocmd({ "StdinReadPre" }, {
			callback = function()
				vim.notify("dotfiles/resession.nvim: StdinReadPre", vim.log.levels.DEBUG)
				StartedWithStdin = true
			end,
		})

		vim.api.nvim_create_autocmd("VimLeave", {
			callback = function()
				if EnableAutoSession == false then
					vim.notify("dotfiles/resession.nvim: EnableAutoSession is false", vim.log.levels.DEBUG)
					return
				end

				resession.save(SessionName)
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			nested = true,
			callback = function()
				local dir = ""

				if StartedWithStdin then
					vim.notify("dotfiles/resession.nvim: started_with_stdin", vim.log.levels.DEBUG)
					return
				elseif vim.fn.argc() == 0 then
					vim.notify("dotfiles/resession.nvim: argc == 0, forceload true", vim.log.levels.DEBUG)
					EnableAutoSession = true
				elseif vim.fn.argc() == 1 then
					dir = vim.fn.expand(vim.fn.argv(0))
					dir = string.gsub(dir, "^oil://", "")
					vim.notify("dotfiles/resession.nvim: argc == 1, dir: " .. dir, vim.log.levels.DEBUG)
					if dir == "." then
						dir = vim.fn.getcwd()
					end

					if vim.fn.isdirectory(dir) ~= 0 then
						vim.notify("dotfiles/resession.nvim: argc == 1, forceload true", vim.log.levels.DEBUG)
						EnableAutoSession = true
					end
				end

				vim.notify(
					"dotfiles/resession.nvim: EnableAutoSession: " .. vim.inspect(EnableAutoSession),
					vim.log.levels.DEBUG
				)
				if EnableAutoSession then
					local session_dir_path = vim.fn.fnamemodify(dir, ":p")

					local function trim(s)
						return (s:gsub("^%s*(.-)%s*$", "%1"))
					end
					local open_pop = assert(io.popen("git rev-parse --show-toplevel", "r"))
					local repo_root = trim(open_pop:read("*all"))

					if repo_root then
						session_dir_path = repo_root
					end

					-- Get the full path of the directory and make sure it doesn't have a trailing path_separator to make sure we find the session
					SessionName = session_name_from_path(session_dir_path)
					vim.notify(
						"dotfiles/resession.nvim: SessionName: " .. vim.inspect(SessionName),
						vim.log.levels.DEBUG
					)

					-- Attempt to load a session, if it's missing, the VimLeave autocmd will create it
					resession.load(SessionName, {
						silence_errors = true,
					})

					-- Hack to get gitsigns and whatnot running on the opened buffers.
					vim.cmd.doautoall("BufReadPre")
				end
			end,
		})
	end,
}
