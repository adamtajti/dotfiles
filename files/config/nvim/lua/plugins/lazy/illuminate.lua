--- Neovim plugin for automatically highlighting other uses of the word under
--- the cursor using either LSP, Tree-sitter, or regex matching.
--- https://github.com/RRethy/vim-illuminate
return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- providers: provider used to get references in the buffer, ordered by priority
		providers = { "lsp", "treesitter" },
		-- delay: delay in milliseconds
		delay = 25,
		-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
		filetypes_denylist = { "dirvish", "fugitive", "alpha", "oil" },
		-- under_cursor: whether or not to illuminate under the cursor
		under_cursor = true,
		-- large_file_cutoff: number of lines at which to use large_file_config
		-- The `under_cursor` option is disabled when this cutoff is hit
		large_file_cutoff = 10000,
	},
	config = function(_, opts)
		require("illuminate").configure(opts)
		vim.cmd([[hi IlluminatedWordText gui=bold guibg=#111111]])
		vim.cmd([[hi IlluminatedWordRead gui=bold guibg=#111111]])
		vim.cmd([[hi IlluminatedWordWrite gui=bold guibg=#111111]])
	end,
}
