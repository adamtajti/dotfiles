--- moonfly is a dark charcoal theme for modern Neovim and classic Vim.
--- https://github.com/bluz71/vim-moonfly-colors
return {
	"bluz71/vim-moonfly-colors",
	name = "moonfly",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.moonflyTransparent = true
		vim.g.moonflyNormalFloat = true
		vim.g.moonflyVirtualTextColor = true
		vim.g.moonflyUndercurls = true
		vim.g.moonflyWinSeparator = 2

		vim.opt.fillchars = {
			horiz = "━",
			horizup = "┻",
			horizdown = "┳",
			vert = "┃",
			vertleft = "┫",
			vertright = "┣",
			verthoriz = "╋",
		}

		vim.api.nvim_set_hl(0, "VertSplit", { fg = "#080808", bg = "#080808" })

		-- toggle them with :GitSigns toggle_linehl
		vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#080808" })
		vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#080808" })

		local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "moonfly",
			callback = function()
				vim.api.nvim_set_hl(0, "PreProc", { fg = "#36c692" })
				vim.api.nvim_set_hl(0, "String", { fg = "#85dc85" })
				vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#C2DDFF" })
				vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "#0A0A0A", fg = "#4e4e4e" })
			end,
			group = custom_highlight,
		})

		vim.cmd.colorscheme("moonfly")
	end,
}
