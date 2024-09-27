-- Entry point for nvim configuration
--
-- The script is transforming into a modularized configuration.

-- Theming:
-- - Catppuccin: Sets a colorscheme with hi groups for other plugins as well.

---------------------------------------------------------------------------------------------------
-- GUI Frontend Configurations
---------------------------------------------------------------------------------------------------

--[[ if vim.g.vscode then
end ]]

if vim.g.neovide then
	-- Setting the GUI font to 0xProto Nerd Font Mono
	vim.o.guifont = "0xProto Nerd Font Mono:h12"
	vim.opt.linespace = 4
	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end)
	vim.g.neovide_scroll_animation_length = 0.07
	vim.g.neovide_hide_mouse_when_typing = false
	vim.g.neovide_confirm_quit = false
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_profiler = false
	vim.g.neovide_cursor_animation_length = 0.07
	vim.g.neovide_cursor_trail_size = 0.07
	vim.g.neovide_cursor_vfx_mode = "sonicboom"
	vim.keymap.set("n", "<C-s>", ":w<CR>")     -- Save
	vim.keymap.set("v", "<C-c>", '"+y')        -- Copy
	vim.keymap.set("n", "<C-v>", '"+P')        -- Paste normal mode
	vim.keymap.set("v", "<C-v>", '"+P')        -- Paste visual mode
	vim.keymap.set("c", "<C-v>", "<C-R>+")     -- Paste command mode
	vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode
	vim.api.nvim_set_keymap("", "<C-v>", "+p<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("!", "<C-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<C-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<C-v>", "<C-R>+", { noremap = true, silent = true })
end

---------------------------------------------------------------------------------------------------
-- Modularized Configs
---------------------------------------------------------------------------------------------------

-- Settings which are not related to a plugins setup or should be set before their initialization.
require("settings")

-- Settings for winbar? Should I merge this with settings?
-- require("winbar")

-- Loads all of my plugins with my chosen plugin manager
require("plugins")

---------------------------------------------------------------------------------------------------

-- <C-l> removes any search highlighting
vim.api.nvim_set_keymap("", "<C-l>", ":nohl<CR>", { noremap = true })

-- <S-Tab> decreases the identation
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-D>", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "<<", { noremap = true })

-- Toggles QuickFix window (Bookmars, References frequently use this functionality)
vim.api.nvim_set_keymap("", "<F2>", '<cmd>lua require("helpers").ToggleQuickFix()<CR>', { noremap = true })

-- Switch between buffers quickly
vim.api.nvim_set_keymap("n", "<Leader><Tab>", "", {
	desc = "Next Buffer",
	noremap = true,
	callback = function()
		vim.cmd(":silent! bn")
	end,
})

vim.api.nvim_set_keymap("n", "<Leader><S-Tab>", "", {
	desc = "Previous Buffer",
	noremap = true,
	callback = function()
		vim.cmd(":silent! bp")
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>L", "", {
	desc = "Lazy.nvim",
	noremap = true,
	callback = function()
		vim.cmd(":Lazy")
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>Q", "", {
	desc = "Quit NVIM without saving anything",
	noremap = true,
	callback = function()
		vim.cmd(":qa!")
	end,
})

vim.api.nvim_set_keymap("n", ";;", "", {
	desc = ":w Save the current file",
	noremap = true,
	callback = function()
		vim.cmd(":w")
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>W", "", {
	desc = "wq! save and exit",
	noremap = true,
	callback = function()
		vim.cmd(":wq!")
	end,
})

-- Resizes
-- vim.api.nvim_set_keymap("n", "<C-w>+", "", {
-- 	noremap = true,
-- 	callback = function()
-- 		print("resize + called")
-- 		local nvim_height = vim.opt.lines:get()
-- 		local window_height = vim.api.nvim_win_get_height(0)
-- 		local window_to_nvim_ratio = window_height / nvim_height
-- 		local one_minus_window_to_nvim_ratio = 1 - window_to_nvim_ratio
--
-- 		local thirty_percent_of_this_ratio = one_minus_window_to_nvim_ratio * 0.3
-- 		local actual_increment = (nvim_height - window_height) * thirty_percent_of_this_ratio
-- 		print(vim.inspect(actual_increment))
-- 		vim.cmd(":resize +" .. actual_increment)
-- 	end,
-- })
--
-- vim.api.nvim_set_keymap("n", "<C-w>-", "", {
-- 	noremap = true,
-- 	callback = function()
-- 		require("notify")("wtf")
-- 		print("resize - called")
-- 		local nvim_height = vim.opt.lines:get()
-- 		local window_height = vim.api.nvim_win_get_height(0)
-- 		local window_to_nvim_ratio = window_height / nvim_height
--
-- 		local thirty_percent_of_this_ratio = window_to_nvim_ratio * 0.3
-- 		local actual_decrement = (nvim_height - window_height) * thirty_percent_of_this_ratio
-- 		print(vim.inspect(actual_decrement))
-- 		vim.cmd(":resize -" .. actual_decrement)
-- 	end,
-- })
--
-- vim.api.nvim_set_keymap("n", "<C-w><", "", {
-- 	noremap = true,
-- 	callback = function()
-- 		local nvim_width = vim.opt.columns:get()
-- 		local window_width = vim.api.nvim_win_get_width(0)
-- 		local window_to_nvim_ratio = window_width / nvim_width
--
-- 		local thirty_percent_of_this_ratio = window_to_nvim_ratio * 0.3
-- 		local actual_decrement = (nvim_width - window_width) * thirty_percent_of_this_ratio
-- 		vim.cmd(":vertical:resize -" .. actual_decrement)
-- 	end,
-- })
--
-- vim.api.nvim_set_keymap("n", "<C-w>>", "", {
-- 	noremap = true,
-- 	callback = function()
-- 		local nvim_width = vim.opt.columns:get()
-- 		local window_width = vim.api.nvim_win_get_width(0)
-- 		local window_to_nvim_ratio = window_width / nvim_width
--
-- 		local one_minus_window_to_nvim_ratio = 1 - window_to_nvim_ratio
-- 		local thirty_percent_of_this_ratio = one_minus_window_to_nvim_ratio * 0.3
-- 		local actual_increment = (nvim_width - window_width) * thirty_percent_of_this_ratio
-- 		vim.cmd(":vertical:resize +" .. actual_increment)
-- 	end,
-- })

-- -- Floating Window Border Colors: Foreground set to teal, background is set to transparent
-- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=#86CBBF guibg=NONE]])
-- vim.cmd([[highlight FloatBorder guifg=#86CBBF guibg=NONE]])
--
-- -- Floatin Window Background Colors: Foreground is no set, background is set to transparent
-- vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=NONE]])
-- vim.cmd([[highlight NormalFloat guibg=NONE]])

-- Floating Window Rounded Borders Styling
local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

-- Setting the hover handleer to be handled with the rounded borders.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = border,
})

-- Setting the hover handleer to be handled with the rounded borders.
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = border,
})

---------------------------------------------------------------------------------------------------
-- Diagnostics
---------------------------------------------------------------------------------------------------
vim.diagnostic.config({
	-- virtual_text is the text that is visible on the right side of the problematic line
	virtual_text = {
		prefix = "",
		format = function(diagnostic)
			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				return string.format(" %s", diagnostic.message)
			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				return string.format(" %s", diagnostic.message)
			elseif diagnostic.severity == vim.diagnostic.severity.INFO then
				return string.format(" %s", diagnostic.message)
			elseif diagnostic.severity == vim.diagnostic.severity.HINT then
				return string.format(" %s", diagnostic.message)
			end

			return diagnostic.message
		end,
	},
})

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

---------------------------------------------------------------------------------------------------
-- Shortcuts to Copy Relative or Positive Paths or Filenames
---------------------------------------------------------------------------------------------------
vim.api.nvim_set_keymap("n", "<Leader>bpr", "", {
	desc = "Copy Relative Path",
	noremap = true,
	callback = function()
		vim.cmd(':let @+ = expand("%")')
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>bpa", "", {
	desc = "Copy Absolute Path",
	noremap = true,
	callback = function()
		vim.cmd(':let @+ = expand("%:p")')
	end,
})

vim.api.nvim_set_keymap("n", "<Leader>bpn", "", {
	desc = "Copy Filename",
	noremap = true,
	callback = function()
		vim.cmd(':let @+ = expand("%:t")')
	end,
})

---------------------------------------------------------------------------------------------------
-- Note taking specific shortcuts
---------------------------------------------------------------------------------------------------

-- Paste the current time in insert mode (used for journaling)
vim.api.nvim_set_keymap(
	"i",
	"<C-t>",
	"<C-r>=substitute(system('date +%H:%M'), '[\\r\\n]*$', '', '')<CR><ESC>",
	{ noremap = true }
)
