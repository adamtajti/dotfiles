return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-emoji",
		{ "hrsh7th/cmp-cmdline", enabled = true },
		{ "dmitmel/cmp-cmdline-history", enabled = true },
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		-- "hrsh7th/cmp-nvim-lua",
		-- "hrsh7th/cmp-nvim-lsp-signature-help",
		-- "hrsh7th/cmp-nvim-lsp-document-symbol",
	},
	opts = function()
		local luasnip = require("luasnip")
		local cmp = require("cmp")
		cmp.setup({
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			enabled = function()
				local buftype = vim.api.nvim_buf_get_option(0, "buftype")
				if buftype == "prompt" then
					return false
				end
				return true
			end,
			-- This is needed, otherwise the first entry will get selected while typing the
			-- comma between the arguments:
			--
			-- Ex:
			-- rabbitMQChannel.sendToQueue(queue, Buffer.from(`${randOffset + i}`, "utf-8",),
			--                                                                            ^
			-- That would show up the "options" argument and <CR> will insert it.
			preselect = cmp.PreselectMode.None,
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = {
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
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
				-- LSP completions
				{ name = "nvim_lsp" },

				-- Snippets to keep us wet and DRY at the same time
				{ name = "luasnip" },

				-- Disabled for now. I think it was TMI
				--{ name = "treesitter" },

				-- Configures cmp-nvim-lua plugin to get autocompletion for neovim's LUA API as well
				-- { name = "nvim_lua" },

				-- nvim-cmp source for displaying function signatures with the current parameter emphasized:
				{ name = "nvim_lsp_signature_help" },

				-- I'm not sure what document symbols are
				{ name = "nvim_lsp_document_symbol" },

				-- Neorg: documentation in neovim
				{ name = "neorg" },
			}),
		})

		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				-- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
				{ name = "nvim_lsp_document_symbol" },
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- TODO: When I initialize a new object in Golang the completion pop-up appears at the end of the line when I add the comma. This is undesirable. Figure out a way to change this behavior. UPDATE: This happens in TypeScript as well. Super annoying.

		-- Triggers cmp if there are characters before the cursor, but none after it
		-- Taken from https://github.com/hrsh7th/nvim-cmp/issues/519
		-- Disabled: took too long to complete on many buffers, especially when tsserver is utilized
		-- vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
		-- 	callback = function()
		-- 		local line = vim.api.nvim_get_current_line()
		-- 		local cursor = vim.api.nvim_win_get_cursor(0)[2]
		--
		-- 		local current = string.sub(line, cursor, cursor + 1)
		-- 		if current == "." or current == "," or current == " " then
		-- 			cmp.close()
		-- 		end
		--
		-- 		local before_line = string.sub(line, 1, cursor + 1)
		-- 		local after_line = string.sub(line, cursor + 1, -1)
		-- 		if not string.match(before_line, "^%s+$") then
		-- 			if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
		-- 				cmp.complete()
		-- 			end
		-- 		end
		-- 	end,
		-- 	pattern = "*",
		-- })
	end,
}
