--- A blazing fast and easy to configure Neovim statusline written in Lua
--- https://github.com/nvim-lualine/lualine.nvim

-- Sections:
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
return {
	"nvim-lualine/lualine.nvim",
	-- My own fork:
	-- "adamtajti/lualine.nvim",
	-- dir = '~/GitHub/lualine.nvim',
	branch = "master",
	event = "VeryLazy",
	name = "lualine",
	dependencies = {
		"moonfly",
	},
	after = {
		"moonfly",
	},
	opts = function()
		local colors = {
			bg = "#080808",
			fg = "#c6c6c6",
			greya = "#323437",
			greyb = "#373c4d",
			greyc = "#e4e4e4",
			greyd = "#b2b2b2",
			greye = "#9e9e9e",
			greyf = "#949494",
			greyg = "#808080",
			greyh = "#626262",
			greyi = "#4e4e4e",
			greyj = "#444444",
			greyk = "#3a3a3a",
			greyl = "#303030",
			greym = "#262626",
			greyn = "#1c1c1c",
			greyo = "#121212",
			khaki = "#c2c292",
			yellow = "#e3c78a",
			orange = "#de935f",
			coral = "#f09479",
			orchid = "#e196a2",
			lime = "#85dc85",
			green = "#8cc85f",
			emerald = "#36c692",
			blue = "#80a0ff",
			sky = "#74b2ff",
			turquoise = "#79dac8",
			purple = "#ae81ff",
			cranberry = "#e65e72",
			violet = "#cf87e8",
			crimson = "#ff5189",
			red = "#ff5454",
			gspring = "#00875f",
			gmineral = "#314940",
			gbay = "#4d5d8d",
		}

		local modified_moonfly_theme = {
			normal = {
				a = { fg = colors.greya, bg = colors.sky },
				b = { fg = colors.sky, bg = colors.bg },
				c = { fg = colors.sky, bg = colors.bg },
				z = { fg = colors.sky, bg = colors.bg },
			},

			insert = { a = { fg = colors.fg, bg = colors.bg } },
			visual = { a = { fg = colors.fg, bg = colors.bg } },
			replace = { a = { fg = colors.fg, bg = colors.bg } },

			inactive = {
				a = { fg = colors.greyb, bg = colors.bg },
				b = { fg = colors.greyb, bg = colors.bg },
				c = { fg = colors.greyb, bg = colors.bg },
			},
		}

		-- Use a single statusbar
		vim.opt.laststatus = 3

		require("lualine").setup({
			options = {
				theme = modified_moonfly_theme,
				component_separators = "|",
				--section_separators = { left = " ", right = " " },
			},
			disabled_filetypes = {
				statusline = { "*", "packer", "dashboard", "alpha", "oil" },
				-- winbar = { "packer", "dashboard", "alpha" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					-- {
					-- 	require("noice").api.statusline.mode.get,
					-- 	cond = require("noice").api.statusline.mode.has,
					-- 	color = { fg = "#ff9e64" },
					-- },
					"branch",
					"diagnostics",
					{
						"filename",
						file_status = true,
						colored = true,
						path = 3,
						shorting_target = 15,
						symbols = {
							modified = "[m]", -- Text to show when the file is modified.
							readonly = "[ro]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
					"diff",
				},
				lualine_c = {},
				lualine_x = {
					-- Buffers; disabled these in an effort to use dropbar for winbar
					-- {
					-- 	"buffers",
					-- 	show_filename_only = true, -- Shows shortened relative path when set to false.
					-- 	hide_filename_extension = false, -- Hide filename extension when set to true.
					-- 	show_modified_status = true, -- Shows indicator when the buffer is modified.
					-- 	filetype_names = {
					-- 		TelescopePrompt = "Telescope",
					-- 		dashboard = "Dashboard",
					-- 		packer = "Packer",
					-- 		fzf = "FZF",
					-- 		alpha = "Alpha",
					-- 		--oil = "Oil",
					-- 	}, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
					-- 	-- the function receives several arguments
					-- 	-- - number of clicks in case of multiple clicks
					-- 	-- - mouse button used (l(left)/r(right)/m(middle)/...)
					-- 	-- - modifiers pressed (s(shift)/c(ctrl)/a(alt)/m(meta)...)
					-- 	on_click = function(clicks, mouseButtonPressed, modifiersPressed)
					-- 		print(vim.inspect(clicks), vim.inspect(mouseButtonPressed), vim.inspect(modifiersPressed))
					-- 	end,
					-- },
				},
				lualine_y = { "location", "progress" },
				lualine_z = { "selectioncount", "searchcount" },
			},
			-- Winbar configuration; disabled these in an effort to use dropbar for winbar
			-- winbar = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = {},
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	-- encoding: file encoding
			-- 	-- fileformat: displayes a symbol for unix, dos, mac
			-- 	lualine_z = {},
			-- },
			-- inactive_winbar = {
			-- 	lualine_a = {},
			-- 	lualine_b = {},
			-- 	lualine_c = {
			-- 		{
			-- 			"filename",
			-- 			file_status = true,
			-- 			path = 3,
			-- 			shorting_target = 10,
			-- 		},
			-- 	},
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
		})

		--[[ require("lualine").hide({
			place = { "statusline" }, -- The segment this change applies to.
			unhide = false, -- whether to re-enable lualine again/
		}) ]]
	end,
}
