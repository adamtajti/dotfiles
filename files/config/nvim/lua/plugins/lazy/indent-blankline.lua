--- This plugin adds indentation guides to Neovim. It uses Neovim's virtual
--- text feature and no conceal
--- https://github.com/lukas-reineke/indent-blankline.nvim
return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufEnter */*",
	main = "ibl",
	config = function()
		require("ibl").setup({
			indent = {
				char = "┊",
				-- tab_char (string,[])
				highlight = { "TelescopeBorder" },
			},
			-- This is not to be confused with the cursors identation level!
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				highlight = { "Function", "Label" },
				exclude = {
					language = {
						"yaml",
						"norg",
						"markdown",
					},
					node_type = {
						yaml = {
							"*",
						},
						norg = {
							"*",
						},
					},
				},
			},
			exclude = {
				filetypes = {
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"gitcommit",
					"TelescopePrompt",
					"TelescopeResults",
					"",
					"neorg",
					"norg",
				},
			},
		})
	end,
}
