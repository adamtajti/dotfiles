-- This was pretty slow and I'm checking if others are faster

-- I'm planning to give this a try, as oil.nvim would probably work with this
-- https://github.com/stevearc/resession.nvim
return {
	"jedrzejboczar/possession.nvim",
	lazy = false, -- yeah, it should load pretty soon to reload the session
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("possession").setup({
			session_dir = vim.fn.stdpath("data") .. "/possession",
			silent = false,
			load_silent = true,
			debug = false,
			logfile = false,
			prompt_no_cr = false,
			autosave = {
				current = true, -- or fun(name): boolean
				cwd = false,
				tmp = false,  -- or fun(): boolean
				tmp_name = "tmp", -- or fun(): string
				on_load = true,
				on_quit = true,
			},
			commands = {
				save = "PossessionSave",
				load = "PossessionLoad",
				rename = "PossessionRename",
				close = "PossessionClose",
				delete = "PossessionDelete",
				show = "PossessionShow",
				list = "PossessionList",
				migrate = "PossessionMigrate",
			},
			hooks = {
				before_save = function(name)
					return {}
				end,
				after_save = function(name, user_data, aborted) end,
				before_load = function(name, user_data)
					return user_data
				end,
				after_load = function(name, user_data) end,
			},
			plugins = {
				close_windows = {
					hooks = { "before_save", "before_load" },
					preserve_layout = true, -- or fun(win): boolean
					match = {
						floating = true,
						buftype = {},
						filetype = {},
						custom = false, -- or fun(win): boolean
					},
				},
				delete_hidden_buffers = false,
				nvim_tree = true,
				neo_tree = true,
				symbols_outline = true,
				tabby = false,
				dap = true,
				dapui = true,
				neotest = true,
				delete_buffers = false,
			},
			telescope = {
				previewer = {
					enabled = true,
					previewer = "pretty", -- or 'raw' or fun(opts): Previewer
					wrap_lines = true,
					include_empty_plugin_data = false,
					cwd_colors = {
						cwd = "Comment",
						tab_cwd = { "#cc241d", "#b16286", "#d79921", "#689d6a", "#d65d0e", "#458588" },
					},
				},
				list = {
					default_action = "load",
					mappings = {
						save = { n = "<c-x>", i = "<c-x>" },
						load = { n = "<c-v>", i = "<c-v>" },
						delete = { n = "<c-t>", i = "<c-t>" },
						rename = { n = "<c-r>", i = "<c-r>" },
					},
				},
			},
		})

		-- Register a command to open Telescope with Possession
		vim.api.nvim_create_user_command(
			"PossessionTelescope",
			":lua = require('telescope').extensions.possession.list()",
			{
				desc = "Views the Sessions in a Telescope View",
				nargs = 0,
			}
		)
	end,
}