return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = function()
		local wk = require("which-key")
		wk.setup({
			preset = "modern",
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
			triggers = "auto",
		})

		wk.add({
			{ "<leader>B",   group = "Bookmarks" },
			{ "<leader>G",   group = "GitHub" },
			{ "<leader>P",   group = "Planary" },
			{ "<leader>b",   group = "Buffers" },
			{ "<leader>bp",  group = "Path" },
			{ "<leader>d",   group = "Diagnostics" },
			{ "<leader>g",   group = "Git" },
			{ "<leader>gt",  group = "Toggle" },
			{ "<leader>gtb", group = "Blame" },
			{ "<leader>m",   group = "Markdown" },
			{ "<leader>s",   group = "Search" },
			{ "<leader>t",   group = "Testing" },
		});

		wk.add({
			mode = { "x" },
			{ "<leader>r", group = "Refactor" },
		})
	end,
}
