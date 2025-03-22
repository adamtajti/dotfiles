-- Temporary test module for the https://github.com/adamtajti/luaopenssl fork
return {
  "adamtajti/luaopenssl",
  enabled = true,
  dev = true,
  build = "rockspec",
  event = "VeryLazy",
}
