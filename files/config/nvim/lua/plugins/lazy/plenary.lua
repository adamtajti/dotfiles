-- Plenary provides many utilities. Direct dependency seems to be necessary to run test files.
return {
	"nvim-lua/plenary.nvim",
	init = function()
		-- The keymap was much more simpler than this, but I wanted to use <Leader>p for :pwd
		vim.api.nvim_set_keymap("n", "<Leader><Leader>P", "", {
			desc = "Test Current File",
			noremap = true,
			callback = function()
				require("plenary.test_harness").test_directory(vim.fn.expand("%:p"))
			end,
		})
	end,
}
