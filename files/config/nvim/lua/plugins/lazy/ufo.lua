return {
	"kevinhwang91/nvim-ufo",
	enabled = false,
	event = "VeryLazy",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	opts = function()
		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "NeogitStatus", "log" },
			callback = function()
				require("ufo").detach()
				vim.opt_local.foldenable = false
				vim.opt_local.foldcolumn = "0"
			end,
		})
	end,
}
