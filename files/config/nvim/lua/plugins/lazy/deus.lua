--- This is my own plugin. I try to collect little snippets and whatnots here.
return {
	name = "lazy-deus",
	dir = "~/.config/nvim/lua/plugins/lazy/deus.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvimtools/none-ls.nvim",
		"rcarriga/nvim-notify",
		"folke/which-key.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("deus").setup({})
	end,
}
