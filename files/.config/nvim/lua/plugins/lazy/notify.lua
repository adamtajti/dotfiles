return {
	"rcarriga/nvim-notify",
	branch = "master",
	name = "notify",
	event = "VeryLazy",
	opts = {
		--background_colour = "NotifyBackground",
		-- background_colour = "#000000",
		stages = "static",
		top_down = true,
		timeout = false,
		render = "wrapped-compact",
	},
	config = function(_, lazy_opts)
		require("notify").setup(lazy_opts)

		---@diagnostic disable-next-line: duplicate-set-field
		vim.notify = function(msg, level, opts)
			opts = opts or {}

			local wordCount = 0
			for _ in msg:gmatch("%S+") do
				wordCount = wordCount + 1
			end

			local averageReadingSpeed = 600 -- words per minute
			local minutesToRead = wordCount / averageReadingSpeed
			-- 500ms gets added so that the attention can be grabbed
			local millisecondsToRead = 400 + minutesToRead * 60 * 1000

			opts.timeout = math.floor(millisecondsToRead)

			require("notify")(msg, level, opts)
		end
	end,
}
