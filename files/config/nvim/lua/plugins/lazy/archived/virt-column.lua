-- Use a `|` character for the right hand line width ruler
return {
	"lukas-reineke/virt-column.nvim",
	name = "virt-column",

	enabled = false,
	event = "BufReadPre",
	after = {
		"moonfly",
	},
	opts = function()
		require("virt-column").setup({ virtcolumn = "100" })
		vim.api.nvim_set_hl(0, "VirtColumn", { fg = "#040609", bg = nil })
		vim.api.nvim_set_hl(0, "ColorColumn", { fg = nil, bg = nil })
	end,
}
