return {
	"Dynge/gitmoji.nvim",
	lazy = false,
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	opts = {
		filetypes = { "NeogitCommitMessage" },
		completion = {
			append_space = false,
			complete_as = "emoji",
		},
	},
	ft = {
		"NeogitCommitMessage",
	},
}
