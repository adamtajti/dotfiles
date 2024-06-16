--- Neorg (Neo - new, org - organization) is a Neovim plugin designed to
--- reimagine organization as you know it. Grab some coffee, start
--- writing some notes, let your editor handle the rest.
--- https://github.com/nvim-neorg/neorg
return {
	"nvim-neorg/neorg",
	lazy = false,
	--cmd = "Neorg",
	--version = "*",
	version = "v7.*",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"saadparwaiz1/cmp_luasnip",
		-- { "vhyrro/luarocks.nvim" },
	},
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						default_workspace = "notes",
						-- I had issues with this, it simply overwritten the buffer that I
						-- had opened at startup
						open_last_workspace = false,
						index = "index.norg",
						workspaces = {
							notes = os.getenv("NOTEBOOK_PATH"),
						},
					},
				},
				-- Current keybinds:
				-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
				["core.keybinds"] = {
					config = {
						default_keybinds = true,
					},
				},
				["core.journal"] = {
					-- https://github.com/nvim-neorg/neorg/wiki/Journal#configuration
					config = {
						journal_folder = "resources/journal",
						strategy = "flat",
						template_name = "journal-template.norg",
						use_template = true,
					},
				},
				--[[ ["external.templates"] = {
					config = {
						templates_dir = get_notebook_path(),
						default_subcommand = "add", -- `:Norg templates journal` will add to the end of the current buffer
					},
				}, ]]
				-- Alt+Enter: new header, list item
				["core.itero"] = {},
				-- << and >> increases header identation
				["core.promo"] = {},
				-- Create tasks with ctrl + space or gtu
				["core.qol.todo_items"] = {},
				["core.concealer"] = {
					config = {
						icon_preset = "basic",
						folds = true,
						icons = {
							todo = {
								done = { icon = "✓" },
								pending = { icon = "…" },
								undone = { icon = " " },
								uncertain = { icon = "~" },
								on_hold = { icon = "=" },
								cancelled = { icon = "×" },
								recurring = { icon = "↺" },
								urgent = { icon = "⚠" },
							},
						},
					},
				},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
						name = "Neorg",
					},
				},
				["core.esupports.indent"] = {
					config = {
						dedent_excess = true,
						format_on_enter = true,
						format_on_escape = true,
						tweaks = {
							unordered_list1 = 0,
							unordered_list2 = 1,
							unordered_list3 = 2,
							unordered_list4 = 3,
							unordered_list5 = 4,
						},
					},
				},
			},
		})

		vim.api.nvim_create_autocmd({ "BufWrite" }, {
			pattern = { "*.norg" },
			callback = function(_)
				vim.cmd(vim.api.nvim_replace_termcodes("normal gg=G<C-o>", true, true, true))
				vim.o.wrap = true
			end,
		})
	end,
}
