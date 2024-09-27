--- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
--- https://github.com/sindrets/diffview.nvim
return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	config = function()
		local diffview = require("diffview")
		diffview.setup({})

		vim.api.nvim_set_keymap("n", "<Leader>bgd", "", {
			desc = "File History",
			noremap = true,
			callback = function()
				diffview.file_history(nil, "%")
			end,
		})
	end,
}
