-- ZenMode
return {
	"folke/zen-mode.nvim",
	name = "zen-mode",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		window = {
			backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			-- height and width can be:
			-- * an absolute number of cells when > 1
			-- * a percentage of the width / height of the editor when <= 1
			-- * a function that returns the width or the height
			width = 1, -- width of the Zen window
			height = 1, -- height of the Zen window
			-- by default, no options are changed for the Zen window
			-- uncomment any of the options below, or add other vim.wo options you want to apply
			options = {
				-- signcolumn = "no", -- disable signcolumn
				-- number = false, -- disable number column
				-- relativenumber = false, -- disable relative numbers
				-- cursorline = false, -- disable cursorline
				-- cursorcolumn = false, -- disable cursor column
				-- foldcolumn = "0", -- disable fold column
				-- list = false, -- disable whitespace characters
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
			},
			twilight = { enabled = false },
			gitsigns = { enabled = true },
			tmux = { enabled = false }, -- disables the tmux statusline

			-- this will change the font size on kitty when in zen mode
			-- to make this work, you need to set the following kitty options:
			-- - allow_remote_control socket-only
			-- - listen_on unix:/tmp/kitty
			-- kitty = {
			-- 	enabled = false, -- 	font = "+2", -- font size increment -- },
		},
	},
	keys = {
		{
			"<Leader>z",
			function()
				require("zen-mode").toggle()
			end,
			desc = "Zen Mode",
			noremap = true,
		},
	},
}
