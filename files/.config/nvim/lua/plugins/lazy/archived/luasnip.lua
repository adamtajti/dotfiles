--- Snippet Engine for Neovim written in Lua.
--- https://github.com/L3MON4D3/LuaSnip

local M = {
  "L3MON4D3/LuaSnip",
  branch = "master",
  -- version = "v2.*",
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
function M.reload() M.force_load_lua_snippets() end

-- This is where my files gets mapped, but it's probably better to detect
-- a change right at the source, since a single lua file could be mapped to many different places.
M.local_snippets_base_dir = vim.fn.expand("$HOME/.local/snippets")
M.dotfiles_snippets_base_dir =
  vim.fn.expand("$HOME/GitHub/dotfiles/files/.local/snippets")

-- Not utilized yet, but I'm planning to hook on all the snippets files in a directory.
M.watches = {}

-- M.w = vim.uv.new_fs_event()
function M.on_change(err, fname, status)
  --print(fname .. " has changed. status: " .. vim.inspect(status) .. ". error: " .. vim.inspect(err))
  local path = M.local_snippets_base_dir .. "/luasnippets/" .. fname
  -- M.watch_snippet_file(path)
  M.debounced_reload(path)
end

--- Watch a snippet file for changes and reload it when it changes.
--- This is the most important function
function M.watch_snippet_file(path)
  if M.watches[path] then
    --print("Already watching this file (" .. path .. "), skipping...")
    return
  end

  M.watches[path] = vim.uv.new_fs_event()
  --print("start watching this file: '" .. path .. "'")
  M.watches[path]:start(
    path,
    {},
    vim.schedule_wrap(function(...) M.on_change(...) end)
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

function M.force_load_lua_snippets()
  -- Start adding Lua snippets, as they automatically reload and they should
  -- be faster, more advanced over time...
  local lua_snippets_base_path = M.local_snippets_base_dir .. "/luasnippets"
  local lua_loader = require("luasnip.loaders.from_lua")
  lua_loader.clean()
  lua_loader.lazy_load({
    paths = { lua_snippets_base_path },
    fs_event_providers = {
      autocmd = true, -- this is the default
      libuv = true, -- this should be the best to support hot reloads
    },
  })
end

-- The configuration is intentionally placed at the last part of this script so there is place for other logic that should be present in this module.
M.config = function(_, opts)
  local ls = require("luasnip")
  ls.config.set_config(opts)
  ls.log.set_loglevel("info")

  -- Load all VS Code snippets that are provided by default
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Load all Lua snippets (forcefully)
  M.force_load_lua_snippets()

  -- Watch the snippets in my dotfiles directory and reload if they change
  local lua_snippets_base_path = M.dotfiles_snippets_base_dir .. "/luasnippets"
  local loader_util = require("luasnip.loaders.util")
  -- local snippets_paths = loader_util.get_ft_paths(M.snippets_base_dir, "lua")
  -- print("snippets_paths: " .. vim.inspect(snippets_paths))
  local load_paths_result = loader_util.get_load_paths_snipmate_like({
    paths = { lua_snippets_base_path },
    fs_event_providers = {
      autocmd = true, -- this is the default
      libuv = true, -- this should be the best to support hot reloads
    },
  }, nil, ".lua")

  local entries = load_paths_result[1]["collection_paths"]
  -- print("entries: " .. vim.inspect(entries))

  for i, entry in pairs(entries) do
    -- turn this into a debug log once I learned how to do that
    --print("entry[" .. i .. "]: ")
    for j, path in ipairs(entry) do
      -- turn this into a debug log once I learned how to do that
      --print("  path[" .. j .. "]: " .. path)
      M.watch_snippet_file(path)
    end
  end

  -- -- local paths = { M.snippets_base_dir .. "/luasnippets/all.lua" }
  -- local collection_roots = loader_util.resolve_root_paths({ M.snippets_base_dir }, "luasnippets")
  -- print("collection_roots: " .. vim.inspect(collection_roots))
  -- local lazy_roots = loader_util.resolve_lazy_root_paths({ lua_snippets_base_path })
  -- print("lazy_roots: " .. vim.inspect(lazy_roots))

  -- I wasn't able to get whole directory watching working, I'm trying this way now.
  -- Uncommented for now as I'm also changing the structure of the snippets.
  -- M.watch_snippet_file(M.snippets_base_dir .. "/luasnippets/all.lua")

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

  vim.keymap.set(
    { "i" },
    "<C-K>",
    function() ls.expand() end,
    { silent = true }
  )
  vim.keymap.set(
    { "i", "s" },
    "<C-L>",
    function() ls.jump(1) end,
    { silent = true }
  )
  vim.keymap.set(
    { "i", "s" },
    "<C-J>",
    function() ls.jump(-1) end,
    { silent = true }
  )

  vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })
end

return M
