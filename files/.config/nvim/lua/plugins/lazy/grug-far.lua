return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar" },
	-- event = "VeryLazy",
	config = true,
	keys = {
		{
			"<Leader>!!!!!!!!",
			function()
				local grug = require("grug-far")
				grug.open({})
			end,
			desc = "",
			noremap = true,
		},
	},
}
