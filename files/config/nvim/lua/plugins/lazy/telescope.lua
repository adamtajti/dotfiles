local last_picker = nil

-- Telescope was used in place of fzf to provide a fuzzy file searcher for code navigation
-- Now it's used for a couple of git operations as well. To look at recently opened files.
-- To show the currently occupied ports on the system
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{
			"LennyPhoenix/project.nvim",
			branch = "fix-get_clients",
		},
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-project.nvim",
		"LinArcX/telescope-ports.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"benfowler/telescope-luasnip.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		-- "tom-anders/telescope-vim-bookmarks.nvim",
		"adamtajti/telescope-vim-bookmarks.nvim",
		"notify",
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope-live-grep-args.nvim"
	},
	cmd = "Telescope",
	opts = function()
		local delete_buffer_forcefully = function(prompt_bufnr)
			local action_state = require("telescope.actions.state")
			local current_picker = action_state.get_current_picker(prompt_bufnr)
			current_picker:delete_selection(function(selection)
				local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, {
					force = true,
				})
				return ok
			end)
		end

		local change_cwd_to_git = function(prompt_bufnr)
			local git_directory = require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
			if git_directory then
				require("telescope.actions").close(prompt_bufnr)
				vim.api.nvim_set_current_dir(git_directory)
				local notify = require("notify")
				notify("CWD: " .. git_directory, "success", { render = "minimal" })
				last_picker()
			end
		end

		local actions = require("telescope.actions")

		local tulip_path = os.getenv("TULIP_PATH")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<Leader>d"] = actions.delete_buffer,
						["<Leader>D"] = delete_buffer_forcefully,
						["<S-ESC>"] = delete_buffer_forcefully,
						["<C-CR>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<S-CR>"] = actions.send_to_qflist + actions.open_qflist,
						-- **c**change cwd to **g**it
						["<Leader>cg"] = change_cwd_to_git,
						["<C-g>"] = change_cwd_to_git,
					},
					n = {
						-- **c**changecwd to **g**it
						["<Leader>cg"] = change_cwd_to_git,
					},
				},
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						width = 0.99,
						height = 0.99,
						mirror = true,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,              -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case",  -- or "ignore_case" or "respect_case. the default case_mode is "smart_case"
				},
			},
		})

		local telescope = require("telescope")

		-- fzf-native is a c port of fzf. It only covers the algorithm and implements few functions to
		-- support calculating the score.
		telescope.load_extension("fzf")

		-- An extension for telescope.nvim that allows you to switch between projects.
		telescope.load_extension("projects")

		-- Shows ports that are open on your system and gives you the ability to kill their
		-- process.(linux only)
		telescope.load_extension("ports")

		-- Integration for nvim-dap with telescope.nvim. This plugin is also overriding dap internal ui,
		-- so running any dap command, which makes use of the internal ui, will result in a telescope
		-- prompt.
		telescope.load_extension("dap")

		-- Session management
		-- telescope.load_extension("persisted")

		-- Snippets
		telescope.load_extension('luasnip')

		-- Pass arguments to the live grep search
		telescope.load_extension("live_grep_args")
	end,
	keys = {
		{
			"<leader>sf",
			function()
				last_picker = require("telescope.builtin").find_files
				last_picker({
					hidden = true,
				})
			end,
			desc = "Find Files (CWD)",
			noremap = true,
		},
		{
			"<C-s>",
			mode = "i",
			function()
				require 'telescope'.extensions.luasnip.luasnip {}
			end,
			desc = "Find snippet",
			noremap = true,
		},
		{
			"<leader>Sf",
			function()
				require 'telescope'.extensions.luasnip.luasnip {}
			end,
			desc = "Find snippet",
			noremap = true,
		},
		{
			"<Leader>gsf",
			function()
				last_picker = require("telescope.builtin").git_files
				last_picker({
					hidden = true,
					show_untracked = true
				})
			end,
			desc = "Search Files",
			noremap = true,
		},
		{
			"<Leader>st",
			function()
				last_picker = require("telescope").extensions.live_grep_args.live_grep_args
				last_picker({
					hidden = true,
					additional_args = {
						"--hidden"
					}
				})
			end,
			desc = "Search Text (CWD)",
			noremap = true,
		},
		{
			"<leader>sn",
			function()
				local notebook_path = os.getenv("NOTEBOOK_PATH")
				last_picker = require("telescope.builtin").find_files
				last_picker({
					cwd = notebook_path,
					hidden = true,
				})
			end,
			desc = "Find Files (Notebook)",
			noremap = true,
		},
		{
			"<Leader>sN",
			function()
				local notebook_path = os.getenv("NOTEBOOK_PATH")
				last_picker = require("telescope").extensions.live_grep_args.live_grep_args
				last_picker({
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
			"<Leader>soc",
			function()
				last_picker = require("telescope.builtin").oldfiles
				last_picker({
					only_cwd = true,
				})
			end,
			desc = "Search Old Files (cwd)",
			noremap = true,
		},
		{
			"<Leader>sog",
			function()
				last_picker = require("telescope.builtin").oldfiles
				last_picker({
				})
			end,
			desc = "search oldfiles (global)",
			noremap = true,
		},
		{
			"<Leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Search across Help Tags",
			noremap = true,
		},
		{
			"<Leader>sT",
			function()
				require("telescope.builtin").treesitter()
			end,
			desc = "Search in Treesitter Tags",
			noremap = true,
		},
		{
			"<Leader>sr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Resume Previous Search",
			noremap = true,
		},
		{
			"<Leader>sp",
			function()
				require("telescope").extensions.projects.projects({})
			end,
			desc = "Search Projects",
			noremap = true,
		},
		{
			"<Leader>gc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "Commits",
			noremap = true,
		},
		{
			"<Leader>gC",
			function()
				require("telescope.builtin").git_bcommits()
			end,
			desc = "Git commits for the current buffer; visual-select lines to track changes in the range",
			noremap = true,
			mode = { "n", "x" },
		},
		{
			"<Leader>gb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "Branches",
			noremap = true,
		},
		{
			"<Leader>bl",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "List Buffers",
			noremap = true,
		},
		{
			"<F2>h",
			function()
				require("telescope.builtin").quickfixhistory()
			end,
			desc = "quickfixhistory",
			noremap = true,
		},
	},
}
