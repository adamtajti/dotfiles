--- Snippet Engine for Neovim written in Lua.
--- https://github.com/L3MON4D3/LuaSnip

local M = {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	dependencies = {
		-- Snippets loaded from VS Code (this should make it easier to share with others)
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
	},
	opts = { history = true, enable_autosnippets = true },
}

-- reload reloads this plugin. I decided to seperate this here, since I want
-- to call it from a hotkey and a file change hook.
function M.reload()
	vim.cmd([[ Lazy reload LuaSnip ]])
	-- This obviously won't reaload it all. I'm leaving it here in case I can't get
	-- the automatic reload working to iterate on...
	-- require("luasnip.loaders").reload_file(lua_snippets_base_path .. "/all.lua")
end

M.snippets_base_dir = vim.fn.expand("$HOME/.local/snippets")
M.w = vim.uv.new_fs_event()
function M.on_change(err, fname, status)
	print(fname .. " has changed. status: " .. vim.inspect(status) .. ". error: " .. vim.inspect(err))
	M.w:stop()

	local path = M.snippets_base_dir .. "/luasnippets/" .. fname
	M.watch_snippet_file(path)
	M.debounced_reload(path)
end

function M.watch_snippet_file(path)
	--print("start watching this file: '" .. path .. "'")
	M.w:start(
		path,
		{},
		vim.schedule_wrap(function(...)
			M.on_change(...)
		end)
	)
end

M.debounced_reload = setmetatable({
	timers = {},
	queued_buffers = {},
}, {
	---@param filepath string
	__call = function(self, filepath)
		local uv = vim.uv or vim.loop
		if not self.timers[filepath] then
			self.timers[filepath] = uv.new_timer()
		end

		if uv.timer_get_due_in(self.timers[filepath]) <= 50 then
			self.queued_buffers[filepath] = nil
			self.timers[filepath]:start(100, 0, function()
				if self.queued_buffers[filepath] then
					self.queued_buffers[filepath] = nil
					vim.schedule_wrap(M.reload)()
				end
			end)

			M.debounced_reload(filepath)
		else
			self.queued_buffers[filepath] = true
		end
	end,
})

-- The configuration is intentionally placed at the last part of this script so there is place for other logic that should be present in this module.
M.config = function(_, opts)
	require("luasnip").config.set_config(opts)
	-- Load all VS Code snippets that are provided by default
	require("luasnip.loaders.from_vscode").lazy_load()

	-- Start adding Lua snippets, as they automatically reload and they should
	-- be faster, more advanced over time...
	local lua_snippets_base_path = M.snippets_base_dir .. "/luasnippets"
	require("luasnip.loaders.from_lua").lazy_load({
		paths = lua_snippets_base_path,
		fs_event_providers = {
			autocmd = true, -- this is the default
			libuv = true, -- this should be the best to support hot reloads
		},
	})

	-- I wasn't able to get whole directory watching working, I'm trying this way now.
	M.watch_snippet_file(M.snippets_base_dir .. "/luasnippets/all.lua")

	-- A hotkey to reload LuaSnip (to be use in-case new snippets are added)
	-- LUA auto reload should work, but it didn't so far
	vim.api.nvim_set_keymap("n", "<Leader>Sr", "", {
		desc = "Snippet Reload",
		noremap = true,
		callback = function()
			M.reload() -- might be better to call the debounced version if we can get the path easily
		end,
	})

	-- A hotkey to quickly edit a snippet
	vim.api.nvim_set_keymap("n", "<Leader>Se", "", {
		desc = "Snippet Edit",
		noremap = true,
		callback = function()
			-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#edit_snippets
			require("luasnip.loaders").edit_snippet_files(nil)
		end,
	})

	-- A hotkey to check on the current filetype
	vim.api.nvim_set_keymap("n", "<Leader>St", "", {
		desc = "Check Snippet fileType (for luasnip)",
		noremap = true,
		callback = function()
			-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#loaders-1
			print(vim.inspect(require("luasnip").get_snippet_filetypes()))
		end,
	})
end

return M
