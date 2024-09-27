-- Disabled this plugin for now. I'm sticking with norg for the meantime.
return {
	"nvim-orgmode/orgmode",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter", lazy = true },
	},
	event = "VeryLazy",
	config = function()
		-- Setup treesitter
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "org" },
			},
			ensure_installed = { "org" },
		})

		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = "~/Dropbox/Notebook/orgfiles/**/*",
			org_default_notes_file = "~/Dropbox/Notebook/orgfiles/refile.org",
		})
	end,
}
