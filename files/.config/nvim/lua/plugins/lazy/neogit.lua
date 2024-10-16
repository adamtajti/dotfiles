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
		-- https://github.com/NeogitOrg/neogit?tab=readme-ov-file#configuration
		require("neogit").setup({
			disable_signs = false,
			disable_context_highlighting = true,
			disable_commit_confirmation = false,
			signs = {
				section = { ">", "v" },
				item = { ">", "v" },
				hunk = { "", "" },
			},
			integrations = {
				diffview = true,
			},
			kind = "vsplit",
			status = {
				recent_commit_count = 30,
			},
			commit_editor = {
				kind = "tab",
				show_staged_diff = true,
				-- Accepted values:
				-- "split" to show the staged diff below the commit editor
				-- "vsplit" to show it to the right
				-- "split_above" Like :top split
				-- "vsplit_left" like :vsplit, but open to the left
				-- "auto" "vsplit" if window would have 80 cols, otherwise "split"
				staged_diff_split_kind = "vsplit",
				spell_check = true,
				commit_select_view = {
					kind = "vsplit",
				},
				log_view = {
					kind = "vsplit",
				},
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
