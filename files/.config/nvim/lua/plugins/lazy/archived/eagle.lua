return {
	"soulis-1256/eagle.nvim",
	event = "VeryLazy",
	config = function()
		require("eagle").setup({
			-- override the default values found in config.lua
		})

		-- make sure mousemoveevent is enabled
		vim.o.mousemoveevent = true
	end,
}
