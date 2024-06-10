--- Extensible UI for Neovim notifications and LSP progress messages.
--- https://github.com/j-hui/fidget.nvim
return {
	"j-hui/fidget.nvim",
	event = "BufReadPre",
	opts = function()
		require("fidget").setup({
			window = {
				winblend = 100,
			},
		})
	end,
}
