-- DAP UI
return {
	"rcarriga/nvim-dap-ui",
	event = "VeryLazy",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	enabled = false,
	opts = function()
		require("dapui").setup()
	end,
	keys = {
		{
			"<leader>dui",
			function()
				require("dapui").toggle({})
			end,
			desc = "DAP UI",
			noremap = true,
		},
	},
}
