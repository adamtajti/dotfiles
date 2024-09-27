--- Extensible UI for Neovim notifications and LSP progress messages.
--- https://github.com/j-hui/fidget.nvim
return {
	"j-hui/fidget.nvim",
	event = "BufReadPre",
	opts = {
		progress = {
			suppress_on_insert = false,
		},
		notification = {
			window = {
				winblend = 0,
			},
		},
	},
}
