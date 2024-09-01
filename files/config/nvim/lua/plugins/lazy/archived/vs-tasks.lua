-- I didn't use this extensions for a while now and it takes a bit of time
-- to load it up each time
return {
	"EthanJWright/vs-tasks.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("vstask").setup({
			cache_json_conf = false, -- don't read the json conf every time a task is ran
			cache_strategy = "last", -- can be "most" or "last" (most used / last used)
			config_dir = ".vscode", -- directory to look for tasks.json and launch.json
			use_harpoon = false,  -- use harpoon to auto cache terminals
			telescope_keys = {    -- change the telescope bindings used to launch tasks
				vertical = "<C-v>",
				split = "<C-p>",
				tab = "<C-t>",
				current = "<CR>",
			},
			autodetect = { -- auto load scripts
				npm = "on",
			},
			terminal = "toggleterm",
			term_opts = {
				vertical = {
					direction = "vertical",
					size = "80",
				},
				horizontal = {
					direction = "horizontal",
					size = "10",
				},
				current = {
					direction = "float",
				},
				tab = {
					direction = "tab",
				},
			},
		})

		vim.api.nvim_set_keymap(
			"n",
			"<Leader>vta",
			"require'telescope'.extensions.vstask.tasks()<CR>",
			{ desc = "VSCode Tasks", noremap = true }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<Leader>vti",
			"require'telescope'.extensions.vstask.inputs()<CR>",
			{ desc = "VSCode Task Inputs", noremap = true }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<Leader>vth",
			"require'telescope'.extensions.vstask.history()<CR>",
			{ desc = "VSCode Task History", noremap = true }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<Leader>vtl",
			"require'telescope'.extensions.vstask.launch()<CR>",
			{ desc = "VSCode Task Launcher", noremap = true }
		)
	end,
}
