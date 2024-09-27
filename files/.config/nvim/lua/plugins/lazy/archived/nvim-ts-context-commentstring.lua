--- A Neovim plugin for setting the commentstring option based on the cursor location in the file. The location is checked via treesitter queries.
--- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	enabled = false,
	event = "BufEnter",
	config = function()
		vim.g.skip_ts_context_commentstring_module = true
		require("ts_context_commentstring").setup({
			enable_autocmd = true,
			languages = {
				typescript = "// %s",
			},
		})
	end,
}
