return {
	"MeanderingProgrammer/render-markdown.nvim",
	lazy = false,
	opts = {
		heading = {
			left_pad = 1,
		},
		chechkbox = {
			position = "overlay",
		},
	},
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
}
