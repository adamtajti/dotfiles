return {
	"folke/which-key.nvim",
	dependencies = {
		"echasnovski/mini.icons"
	},
	event = "VeryLazy",
	opts = function()
		local wk = require("which-key")
		wk.setup({
			preset = "helix",
			notify = false,
			-- disable = {
			-- 	ft = {
			-- 		"oil",
			-- 	},
			-- 	bt = {
			-- 		"oil",
			-- 	}
			-- },
			plugins = {
				marks = false,
				registers = true,
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = false,
				},
			},
			layout = {
				height = { min = 10, max = 25 },
			},
		})

		wk.add({
			-- I might drop this in the near future
			{ "<leader>B",  group = "Bookmarks" },

			{ "<leader>bp", group = "Path" },
			{ "<leader>d",  group = "Diagnostics" },

			-- CWD Scoped Commands
			{ "<leader>c",  group = "CWD Scoped commands" },

			-- Git Scoped Commands
			{ "<leader>g",  group = "Git Scoped Commands" },
			{ "<leader>gh", group = "Hunks" },

			-- Buffer Scoped Commands
			{ "<leader>b",  group = "Commands on the open buffer(s)" },
			{ "<leader>bg", group = "Git" },

			-- Language related functionalities (LSP, Actions, Testing)
			{ "<leader>l",  group = "Language" },

			-- Like toggling the Colorizer
			{ "<leader>u",  group = "Utilities" },
		});

		wk.add({
			mode = { "x" },
			{ "<leader>r", group = "Refactor" },
		})
	end,
}
