--- 🔥 Solve LeetCode problems within Neovim 🔥
--- https://github.com/kawre/leetcode.nvim
return {
	"kawre/leetcode.nvim",
	event = "VeryLazy",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- configuration goes here
	},
}
