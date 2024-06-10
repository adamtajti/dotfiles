return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function()
		require("which-key").setup({
			plugins = {
				marks = true,
				registers = true,
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = false, -- set to false; possibly conflicts with my Obsidian.nvim plugin
				},
			},
			window = {
				border = "single",
			},
			layout = {
				height = { min = 10, max = 25 },
			},
			triggers = "auto",
		})

		local wk = require("which-key")
		wk.register({
			b = {
				name = "Buffers",
				p = {
					name = "Path",
				},
			},
			B = {
				name = "Bookmarks",
			},
			d = {
				name = "Diagnostics",
			},
			g = {
				name = "Git",
				t = {
					name = "Toggle",
					b = {
						name = "Blame",
					},
				},
			},
			G = {
				name = "GitHub",
			},
			s = {
				name = "Search",
			},
			r = {
				name = "Refactor",
			},
			P = {
				name = "Planary",
			},
			t = {
				name = "Testing",
			},
			m = {
				name = "Markdown",
			},
		}, { prefix = "<leader>", mode = "n" })

		wk.register({
			r = {
				name = "Refactor",
			},
		}, { prefix = "<leader>", mode = "x" })
	end,
}
