return {
	"kevinhwang91/nvim-ufo",
	enabled = true,
	lazy = false,
	-- event = "VeryLazy",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		-- vim.o.foldmethod = "expr"
		-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.o.foldcolumn = "0" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

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
