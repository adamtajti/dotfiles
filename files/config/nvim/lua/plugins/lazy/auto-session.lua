return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim", -- Only needed if you want to use session lens
	},
	opts = {
		-- Enables/disables auto creating, saving and restoring
		enabled = true,
		-- Root dir where sessions will be stored
		root_dir = vim.fn.stdpath("data") .. "/sessions/",
		-- Enables/disables auto saving session on exit
		auto_save = true,
		-- Enables/disables auto restoring session on start
		auto_restore = true,
		-- Enables/disables auto creating new session files. Can take a function that
		-- should return true/false if a new session file should be created or not
		auto_create = true,
		-- Suppress session restore/create in certain directories
		suppressed_dirs = nil,
		-- Allow session restore/create in certain directories
		allowed_dirs = nil,
		-- On startup, loads the last saved session if session for cwd does not exist
		auto_restore_last_session = false,
		-- Include git branch name in session name
		use_git_branch = true,
		-- Automatically detect if Lazy.nvim is being used and wait until Lazy is
		-- done to make sure session is restored correctly. Does nothing if Lazy
		-- isn't being used. Can be disabled if a problem is suspected or for
		-- debugging
		lazy_support = true,
		-- List of file types to bypass auto save when the only buffer open is one
		-- of the file types listed, useful to ignore dashboards
		bypass_save_filetypes = nil,
		-- Close windows that aren't backed by normal file before autosaving a session
		close_unsupported_windows = true,
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

		local started_with_stdin = false

		vim.api.nvim_create_autocmd({ "StdinReadPre" }, {
			callback = function()
				-- vim.notify("dotfiles/auto-session.nvim: StdinReadPre")
				started_with_stdin = true
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local dir = ""
				local forceload = false

				if started_with_stdin then
					-- vim.notify("dotfiles/auto-session.nvim: started_with_stdin")
				elseif vim.fn.argc() == 0 then
					-- vim.notify("dotfiles/auto-session.nvim: argc == 0, forceload true")
					forceload = true
				elseif vim.fn.argc() == 1 then
					dir = vim.fn.expand(vim.fn.argv(0))
					-- vim.notify("dotfiles/auto-session.nvim: argc == 1, dir: " .. dir)
					dir = string.gsub(dir, "^oil://", "")

					if dir == "." then
						dir = vim.fn.getcwd()
					end

					if vim.fn.isdirectory(dir) ~= 0 then
						-- vim.notify("dotfiles/auto-session.nvim: argc == 1, forceload true")
						forceload = true
					end
				end

				local fl_string = "false"
				if forceload then
					fl_string = "true"
				end

				-- vim.notify("dotfiles/auto-session.nvim: forceload: " .. fl_string)

				if forceload then
					local auto_session_lib = require("auto-session.lib")
					local auto_session_config = require("auto-session.config")

					-- Get the full path of the directory and make sure it doesn't have a trailing path_separator
					-- to make sure we find the session
					local session_name = auto_session_lib.remove_trailing_separator(vim.fn.fnamemodify(dir, ":p"))
					auto_session_lib.logger.debug(
						"Launched with single directory, using as session_dir: " .. session_name
					)

					local restored = auto_session.RestoreSession(session_name, false)
					if restored == false then
						auto_session.SaveSession(session_name, false)
					end

					auto_session.AutoSaveSession()
				end
			end,
		})
	end,
}
