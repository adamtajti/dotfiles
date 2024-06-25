--- This is my own plugin. I try to collect little snippets and whatnots here.
return {
	name = "lazy-deus",
	dir = "~/.config/nvim/lua/plugins/lazy/deus.nvim",
	event = "VeryLazy",
	dependencies = {
		"null-ls",
		"notify",
		"folke/which-key.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("deus").setup({})
	end,
}
