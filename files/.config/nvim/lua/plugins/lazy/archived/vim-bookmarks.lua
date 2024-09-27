	-- Extending the standard vim bookmarks with vim-bookmarks
	-- It's my own fork based on use("MattesGroeger/vim-bookmarks")
	-- I removed the Annotation prefixes.
	return {
		"adamtajti/vim-bookmarks",
    dependencies = {
			"nvim-telescope/telescope.nvim",
    },
		init = function()
			vim.api.nvim_set_hl(0, "BookmarkAnnotationSign", { fg = "#D7CCC8", bg = "" })
			vim.api.nvim_set_hl(0, "BookmarkAnnotationLine", { fg = "", bg = "#242837" })
			vim.g.bookmark_no_default_key_mappings = 1
			vim.g.bookmark_sign = "░"
			vim.g.bookmark_annotation_sign = "░"
			vim.g.bookmark_highlight_lines = 1
			vim.g.bookmark_auto_close = 1
		end,
		keys = {
			{
				"<Leader>Bs",
				function()
					local bookmark_actions = require('telescope').extensions.vim_bookmarks.actions
					require('telescope').extensions.vim_bookmarks.all {
						attach_mappings = function(_, map)
							map('n', 'dd', bookmark_actions.delete_selected_or_at_cursor)
							return true
						end
					}
				end,
				desc = "Show all bookmarks in Telescope",
				noremap = true
			},
			{
				"<Leader>Ba",
				":BookmarkAnnotate<CR>",
				desc = "Add/edit bookmark annotation at current line", noremap = true
			}
		},
	}
