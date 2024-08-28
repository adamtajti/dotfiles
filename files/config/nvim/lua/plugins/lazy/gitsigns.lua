--- Super fast git decorations implemented purely in Lua.
--- https://github.com/lewis6991/gitsigns.nvim
return {
	"lewis6991/gitsigns.nvim",
	event = "BufEnter */*",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = {
					text = "▐",
				},
				change = {
					text = "▐",
				},
				delete = {
					text = "▐",
				},
				topdelete = {
					text = "▐",
				},
				changedelete = {
					text = "▐",
				},
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true,   -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author> <author_time:%Y-%m-%d>: <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				---@return string
				map("n", "]g", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Git hunk forward" })

				map("n", "[g", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Git hunk last" })

				map("n", "<leader>ghs", gs.stage_hunk, { silent = true, desc = "Stage hunk" })
				map("n", "<leader>ghr", gs.reset_hunk, { silent = true, desc = "Reset hunk" })
				map("x", "<leader>ghs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("x", "<leader>ghr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("n", "<leader>ghS", gs.stage_buffer, { silent = true, desc = "Stage buffer" })
				map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo staged hunk" })
				map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "gs", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview hunk inline" })

				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, { desc = "Show blame commit" })
				map("n", "<leader>ghd", gs.diffthis, { desc = "Diff against the index" })

				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, { desc = "Diff against the last commit" })

				map("n", "<leader>ghl", function()
					if vim.bo.filetype ~= "qf" then
						require("gitsigns").setqflist(0, { use_location_list = true })
					end
				end, { desc = "Send to location list" })

				map("n", "<leader>bgb", gs.toggle_current_line_blame, { desc = "Toggle Git line blame" })
				map("n", "<leader>bgd", gs.toggle_deleted, { desc = "Toggle Git deleted" })
				map("n", "<leader>bgw", gs.toggle_word_diff, { desc = "Toggle Git word diff" })
				map("n", "<leader>bgl", gs.toggle_linehl, { desc = "Toggle Git line highlight" })
				map("n", "<leader>bgn", gs.toggle_numhl, { desc = "Toggle Git number highlight" })
				map("n", "<leader>bgs", gs.toggle_signs, { desc = "Toggle Git signs" })

				map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true, desc = "Select hunk" })
			end,
		})
	end,
}
