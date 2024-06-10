-- DAP UI
return {
	"rcarriga/nvim-dap-ui",
	lazy = false,
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
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
