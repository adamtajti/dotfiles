--- This is the main entry point of this plugin.
--- The length of this file should be kept to a minimum and the different functionalities
--- shall be implemented in separate modules, aka files.

local M = {}

local snippets = require("deus.snippets")
local dotfiles = require("deus.dotfiles")

function M:setup(options)
	options = options or {}
	self.options = options

	-- An attempt to have live-reloading snippets inside of nvim, with the ability to quickly add new
	-- ones.
	snippets.setup()

	-- Each of my own workstations have ~/GitHub/dotfiles cloned, which sets up the version controlled
	-- configuration files to be tracked.
	dotfiles.setup()

	-- TODO: <Lazy reload deus> itself when one of the lua files change. Look into how Lazy's reload work, as I'll probably need to remove the file watchers on unloading.
end

return M
