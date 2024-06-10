--- luarocks.nvim is a Neovim plugin designed to streamline the installation
--- of luarocks packages directly within Neovim. It simplifies the process
--- of managing Lua dependencies, ensuring a hassle-free experience for
--- Neovim users.
--- I installed it because it was a requirement to other plugins, namely neorg.
--- https://github.com/vhyrro/luarocks.nvim
return {
	"vhyrro/luarocks.nvim",
	priority = 1000, -- We'd like this plugin to load first out of the rest
	config = true, -- This automatically runs `require("luarocks-nvim").setup()`
}
