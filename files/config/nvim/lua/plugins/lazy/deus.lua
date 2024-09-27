local notebook_path = os.getenv("NOTEBOOK_PATH")

--- This is my own plugin. I try to collect little snippets and whatnots here.
return {
	name = "lazy-deus",
	dir = "~/.config/nvim/lua/plugins/lazy/deus.nvim",
	event = "VeryLazy",
	dependencies = {
		"null-ls",
		"notify",
		"folke/which-key.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("deus").setup({})
	end,
	keys = {
		{
			"<leader>nsf",
			function()
				require("telescope.builtin").find_files({
					cwd = notebook_path,
					hidden = true,
				})
			end,
			desc = "Find Files (Notebook)",
			noremap = true,
		},
		{
			"<Leader>nst",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args({
					hidden = true,
					search_dirs = {
						notebook_path,
					},
				})
			end,
			desc = "Search Text (Notebook)",
			noremap = true,
		},
		{
			"<Leader>nso",
			function()
				require("telescope.builtin").oldfiles({
					cwd = notebook_path,
					only_cwd = true,
				})
			end,
			desc = "Previously Opened Files",
			noremap = true,
		},
	},
}
