return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim", -- Only needed if you want to use session lens
		"lewis6991/gitsigns.nvim", -- To load gitsigns over the restored buffers
	},
	opts = {
		-- Enables/disables auto creating, saving and restoring
		enabled = true,
		-- Root dir where sessions will be stored
		root_dir = vim.fn.stdpath("data") .. "/sessions/",
		-- Enables/disables auto saving session on exit
		auto_save = false,
		-- Enables/disables auto restoring session on start
		auto_restore = false,
		-- Enables/disables auto creating new session files. Can take a function that
		-- should return true/false if a new session file should be created or not
		auto_create = false,
		-- Suppress session restore/create in certain directories
		suppressed_dirs = {
			"/",
			"~/",
			"~/Desktop",
			"~/Documents",
			"~/Downloads",
			"~/Dropbox",
			"~/Games",
			"~/GitHub",
			"~/GitLab",
			"~/Pictures",
			"~/Playground",
			"~/Projects",
		},
		-- Allow session restore/create in certain directories
		allowed_dirs = nil,
		-- On startup, loads the last saved session if session for cwd does not exist
		auto_restore_last_session = false,
		-- Include git branch name in session name
		use_git_branch = false,
		-- Automatically detect if Lazy.nvim is being used and wait until Lazy is
		-- done to make sure session is restored correctly. Does nothing if Lazy
		-- isn't being used. Can be disabled if a problem is suspected or for
		-- debugging
		lazy_support = true,
		-- List of file types to bypass auto save when the only buffer open is one
		-- of the file types listed, useful to ignore dashboards
		bypass_save_filetypes = nil,
		-- Close windows that aren't backed by normal file before autosaving a session
		close_unsupported_windows = false,
		-- Follow normal sesion save/load logic if launched with a single
		-- directory as the only argument
		-- Adam: Disabled it because I'm using "oil://..." paths for the directories...
		args_allow_single_directory = false,
		-- Allow saving a session even when launched with a file argument (or
		-- multiple files/dirs). It does not load any existing session first.
		-- While you can just set this to true, you probably want to set it
		-- to a function that decides when to save a session when launched
		-- with file args. See documentation for more detail
		args_allow_files_auto_save = false,
		-- Keep loading the session even if there's an error
		continue_restore_on_error = true,
		-- Follow cwd changes, saving a session before change and restoring after
		cwd_change_handling = false,
		-- Sets the log level of the plugin (debug, info, warn, error).
		log_level = "error",
	},
	config = function(_, opts)
		local auto_session = require("auto-session")
		auto_session.setup(opts)

		local session_dir_path = ""
		local session_name = ""
		local forceload = false

		local started_with_stdin = false
		vim.api.nvim_create_autocmd({ "StdinReadPre" }, {
			callback = function()
				-- vim.notify("dotfiles/auto-session.nvim: StdinReadPre")
				started_with_stdin = true
			end,
		})

		vim.api.nvim_create_autocmd("VimLeave", {
			callback = function()
				if forceload == false then
					print("forceload is false, no need to save")
					return
				end

				auto_session.SaveSession(session_name, false)
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local dir = ""

				if started_with_stdin then
					-- vim.notify("dotfiles/auto-session.nvim: started_with_stdin")
				elseif vim.fn.argc() == 0 then
					-- vim.notify("dotfiles/auto-session.nvim: argc == 0, forceload true")
					forceload = true
				elseif vim.fn.argc() == 1 then
					dir = vim.fn.expand(vim.fn.argv(0))
					dir = string.gsub(dir, "^oil://", "")
					-- vim.notify("dotfiles/auto-session.nvim: argc == 1, dir: " .. dir)
					if dir == "." then
						dir = vim.fn.getcwd()
					end

					if vim.fn.isdirectory(dir) ~= 0 then
						-- vim.notify("dotfiles/auto-session.nvim: argc == 1, forceload true")
						forceload = true
					end
				end

				-- vim.notify("dotfiles/auto-session.nvim: forceload: " .. vim.inspect(forceload))
				if forceload then
					local auto_session_lib = require("auto-session.lib")

					session_dir_path = vim.fn.fnamemodify(dir, ":p")

					local function trim(s)
						return (s:gsub("^%s*(.-)%s*$", "%1"))
					end
					local open_pop = assert(io.popen("git rev-parse --show-toplevel", "r"))
					local repo_root = trim(open_pop:read("*all"))

					-- print("session_dir_path: " .. full_path .. " repo_root: " .. repo_root)
					if repo_root then
						session_dir_path = repo_root
					end

					-- Get the full path of the directory and make sure it doesn't have a trailing path_separator
					-- to make sure we find the session
					session_name = auto_session_lib.remove_trailing_separator(session_dir_path)
					-- vim.notify("dotfiles/auto-session.nvim: session_name: " .. vim.inspect(session_name))

					local restored = auto_session.RestoreSession(session_name, false)
					-- print("dotfiles/auto-session.nvim: restored: " .. vim.inspect(restored))
					if restored == false then
						auto_session.SaveSession(session_name, false)
					else
						local buffers = vim.tbl_filter(function(buf)
							return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
						end, vim.api.nvim_list_bufs())

						for i, buffer in ipairs(buffers) do
							require("gitsigns.attach").attach(buffer)
						end
					end
				end
			end,
		})
	end,
}
