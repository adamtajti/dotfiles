return {
	"renerocksai/telekasten.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	event = "VeryLazy",
	config = function()
		require("telekasten").setup({
			home = vim.fn.expand("~/Dropbox/Notebook"),
		})
	end,
}
