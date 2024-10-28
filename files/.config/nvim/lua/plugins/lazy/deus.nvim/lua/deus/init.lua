--- This is the main entry point of this plugin.
--- The length of this file should be kept to a minimum and the different functionalities
--- shall be implemented in separate modules, aka files.

local M = {}

local snippets = require("deus.snippets")
local dotfiles = require("deus.dotfiles")
local sounds = require("deus.sounds")
local notebook = require("deus.notebook")

function M:setup(options)
  options = options or {}
  self.options = options

  -- Playing sounds for my configured events.
  sounds.setup()

  -- An attempt to have live-reloading snippets inside of nvim, with the ability to quickly add new
  -- ones.
  snippets.setup()

  -- Each of my own workstations have ~/GitHub/dotfiles cloned, which sets up the version controlled
  -- configuration files to be tracked.
  dotfiles.setup()

  -- Notebook hooks and whatnot
  notebook.setup()
end

return M
