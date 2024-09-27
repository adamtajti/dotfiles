return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		"hrsh7th/nvim-cmp",
	},

	-- lazy: false because the bois added an annoying message
	-- https://github.com/neovim/neovim/pull/30382
	-- This should be reverted after this gets fixed in the upstream, because this adds some
	-- latency to the startup time.
	lazy = false,
	enabled = true,
	priority = 49,

	opts = {
		notify = {
			enabled = false,
		},
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		cmdline = {
			enabled = true,
			view = "cmdline",
		},
		popupmenu = {
			enabled = false,
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		routes = {
			{ view = "notify", filter = { event = "msg_showmode" } },
			{ filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
			{ filter = { event = "msg_show", find = "yanked" }, opts = { skip = true } },
			{ filter = { event = "msg_show", find = "to indent" }, opts = { skip = true } },
			{ filter = { event = "msg_show", find = "vim.treesitter.get_parser" }, opts = { skip = true } },
		},
	},
	config = function(_, lazy_opts)
		require("noice").setup(lazy_opts)
	end,
}
