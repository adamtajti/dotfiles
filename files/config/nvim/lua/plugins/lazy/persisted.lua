return {
	"olimorris/persisted.nvim",
	lazy = false, -- make sure the plugin is always loaded at startup
	priority = 60,
	opts = {
		autoload = true,
		autosave = true,
		autostart = true,
		use_git_branch = true,
		on_autoload_no_session = function()
			vim.notify("No existing session to load.")
		end
	},
	config = function(_, opts)
		local persisted = require("persisted")

		---@diagnostic disable-next-line: duplicate-set-field
		persisted.branch = function()
			local branch = vim.fn.systemlist("git branch --show-current")[1]
			return vim.v.shell_error == 0 and branch or nil
		end

		vim.api.nvim_create_autocmd("VimEnter", {
			nested = true,
			callback = function()
				if vim.g.started_with_stdin then
					return
				end

				local forceload = false
				if vim.fn.argc() == 0 then
					vim.notify("dotfiles/persisted.nvim: argc == 0, forceload true")
					forceload = true
				elseif vim.fn.argc() == 1 then
					local dir = vim.fn.expand(vim.fn.argv(0))
					dir = string.gsub(dir, "^oil://", "");

					if dir == '.' then
						dir = vim.fn.getcwd()
					end

					if vim.fn.isdirectory(dir) ~= 0 then
						forceload = true
					end
				end

				persisted.autoload({ force = forceload })
			end,
		})

		persisted.setup(opts)
	end,
}
