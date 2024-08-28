return {
	"norcalli/nvim-colorizer.lua",
	lazy = false,
	config = function()
		require("colorizer").setup({ "*", "!oil" })
	end,
	keys = {
		{
			"<Leader>uc",
			function()
				local colorizer = require("colorizer")
				local is_attached = colorizer.is_buffer_attached(0)

				if is_attached == false then
					colorizer.attach_to_buffer(0)
				else
					colorizer.detach_from_buffer(0)
				end
			end,
			desc = "Toggle Colorize",
			noremap = true,
		},
	},
}
