return {
	"kristijanhusak/vim-dadbod-ui",
	cmd = {
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUI",
		"DBUIFindBuffer",
		"DBUIRenameBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
	end,
	dependencies = {
		{
			"tpope/vim-dadbod",
		},
	},
}
