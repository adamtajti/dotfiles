return {
	"hrsh7th/nvim-cmp",
	event = "VeryLazy",
	dependencies = {
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-cmdline",
		"dmitmel/cmp-cmdline-history",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-omni",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"Dynge/gitmoji.nvim",

		-- I don't think I need this anymore
		-- "jmbuhr/otter.nvim",
	},
	opts = function()
		local luasnip = require("luasnip")
		local cmp = require("cmp")

		local window_completion = cmp.config.window.bordered()
		window_completion.col_offset = -3

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			enabled = function()
				return true
			end,
			preselect = cmp.PreselectMode.None,
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = window_completion,
				-- completion = cmp.config.window.bordered(),
				-- completion = {
				-- 	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
				-- 	col_offset = -3,
				-- 	side_padding = 0,
				-- },
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
			mapping = {
				-- ["<C-k>"] = cmp.mapping.select_prev_item(),
				-- ["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-f>"] = cmp.mapping.scroll_docs(-4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
					assert,
				}),
				["<Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end,
				["<S-Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end,
			},
			sources = cmp.config.sources({
				-- Snippets to keep us wet and DRY at the same time
				{ name = "luasnip" },

				-- Lazydev lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
				{ name = "lazydev" },

				-- LSP completions
				{ name = "nvim_lsp" },

				-- Disabled for now. I think it was TMI
				--{ name = "treesitter" },

				-- nvim-cmp source for displaying function signatures with the current parameter emphasized:
				{ name = "nvim_lsp_signature_help" },

				-- I'm not sure what document symbols are
				{ name = "nvim_lsp_document_symbol" },

				-- Neorg: documentation in neovim
				{ name = "neorg" },

				{ name = "gitmoji" },
				{
					name = "omni",
					option = {
						disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
					},
				},

				{ name = "emoji", option = { insert = true } },
				-- { name = "otter" },
			}),
		})

		cmp.setup.filetype("NeogitCommitMessage", {
			sources = cmp.config.sources({
				{ name = "gitmoji" },
			}),
		})

		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				-- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
				{ name = "nvim_lsp_document_symbol" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}
