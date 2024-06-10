--- A Vim plugin that shows the context of the currently visible buffer contents
--- Lightweight alternative to context.vim
--- https://github.com/nvim-treesitter/nvim-treesitter-context
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "BufReadPre",
	config = true,
	enabled = false,
}
