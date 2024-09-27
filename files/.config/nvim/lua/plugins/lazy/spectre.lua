return {
	"nvim-pack/nvim-spectre",
	cmd = { "Spectre" },
	config = true,
	keys = {
		{
			"<Leader>s",
			function()
				require("spectre").open()
			end,
			desc = "Spectre (Search and Replace)",
			noremap = true,
		},
	},
}
