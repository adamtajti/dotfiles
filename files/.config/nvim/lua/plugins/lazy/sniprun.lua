return {
	"michaelb/sniprun",
	build = "bash ./install.sh",
	opts = {
		display = {
			-- Options:
			-- "Classic" -> display results in the command-line  area
			-- "VirtualText" -> display results as virtual text
			-- "TempFloatingWindow" -> display results in a floating window
			-- "LongTempFloatingWindow" -> same as above, but only long results. To use with VirtualText[Ok/Err]
			-- "Terminal" -> display results in a vertical split
			-- "TerminalWithCode" -> display results and code history in a vertical split
			-- "NvimNotify" -> display with the nvim-notify plugin
			-- "Api" -> return output to a programming interface
			-- "TempFloatingWindow",
			"TerminalWithCode",
		},
	},
	keys = {
		{
			"<Leader><CR>",
			function()
				require("sniprun").run("v")
			end,
			desc = "Evaluate Selected Lines",
			noremap = true,
			mode = { "x" },
		},
		{
			"<Leader><CR>",
			"<cmd>:%SnipRun<CR>",
			desc = "Evaluate Current File (Script)",
			noremap = true,
		},
	},
}
