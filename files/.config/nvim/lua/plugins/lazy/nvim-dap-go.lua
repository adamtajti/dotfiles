-- Golang Debug Adapter Protocol (DAP) Adapter
return {
	"leoluz/nvim-dap-go",
	enabled = false,
	event = "VeryLazy",
	opts = function()
		require("dap-go").setup()
	end,
}
