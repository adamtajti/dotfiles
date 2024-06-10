--- Lens.vim automatically resizes windows when their content exceeds their
--- window dimensions, but does so respecting some minimum and maximum resize
--- bounds ensuring automatically resized windows neither become too large
--- (in cases of large content) or too small (in cases of small content).
--- https://github.com/camspiers/lens.vim
return {
	"camspiers/lens.vim",
	event = "BufEnter */*",
	config = function()
		vim.g["lens#animate"] = 0
		vim.g["lens#width_resize_min"] = 100
		vim.g["lens#disabled_filetypes"] =
			{ "nerdtree", "fzf", "quickfix", "", "diff", "man", "help", "gitcommit", "fugitive" }
		vim.g["lens#disabled_buftypes"] = { "nofile", "lualine", "" }
	end,
}
