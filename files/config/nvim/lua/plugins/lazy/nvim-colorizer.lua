-- Test: Red
return {
	"NvChad/nvim-colorizer.lua",
	lazy = false,
	opts = {
		filetypes = { "*", "!oil" },
	},
	config = function(_, opts)
		require("colorizer").setup(opts)
	end,
	keys = {
		{
			"<Leader>bc",
			function()
				local colorizer = require("colorizer")
				local is_attached = colorizer.is_buffer_attached(0)

				vim.notify("dotfiles/nvim-colorizer.lua: is_attached: " .. vim.inspect(is_attached))
				if is_attached == nil then
					colorizer.attach_to_buffer(0, { mode = "background", css = true })
				else
					colorizer.detach_from_buffer(0)
				end
			end,
			desc = "Toggle Colorize",
			noremap = true,
		},
	},
}
