--- A git interface for Neovim, inspired by Magit.
--- https://github.com/NeogitOrg/neogit
return {
	"NeogitOrg/neogit",
	-- dir = "~/GitHub/neogit.nvim",
	-- dev = true,
	branch = "master",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	config = function()
		require("neogit").setup({
			disable_signs = false,
			disable_context_highlighting = false,
			disable_commit_confirmation = false,
			signs = {
				section = { ">", "v" },
				item = { ">", "v" },
				hunk = { "", "" },
			},
			integrations = {
				diffview = true,
			},
		})
	end,
	cmd = {
		"Neogit",
		"NeogitResetState",
	},
	keys = {
		{
			"<Leader>G",
			function()
				-- Open neogit in the current buffer
				require("neogit").open({ kind = "replace" })
			end,
			desc = "NeoGit",
			noremap = true,
		},
	},
}
