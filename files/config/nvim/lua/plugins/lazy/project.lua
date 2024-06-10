--- project.nvim is an all in one neovim plugin written in lua that provides superior project management.
--- https://github.com/ahmedkhalf/project.nvim
return {
	--"ahmedkhalf/project.nvim",
	"LennyPhoenix/project.nvim",
	branch = "fix-get_clients",
	lazy = false,
	config = function()
		require("project_nvim").setup({
			scope_chdir = "win",
		})
	end,
}
