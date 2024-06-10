return {
	"rcarriga/nvim-notify",
	name = "notify",
	event = "VeryLazy",
	opts = {
		--background_colour = "NotifyBackground",
		background_colour = "#000000",
		stages = "fade",
		timeout = 7777,
		fps = 144,
		top_down = false,
		render = "minimal",
	},
}
