function estimateAdvancedReadingTime(text)
	local words = {}
	local symbolCount = 0
	local totalCharacters = 0
	local complexityFactor = 1

	-- Split text into words and count symbols
	for word in text:gmatch("%S+") do
		table.insert(words, word)
		totalCharacters = totalCharacters + #word

		-- Count special symbols
		symbolCount = symbolCount + select(2, word:gsub("[^%w]", ""))
	end

	local wordCount = #words
	local averageWordLength = totalCharacters / wordCount

	-- Adjust complexity factor based on average word length
	if averageWordLength > 6 then
		complexityFactor = complexityFactor * 1.1
	end

	-- Adjust complexity factor based on symbol density
	local symbolDensity = symbolCount / wordCount
	if symbolDensity > 0.1 then
		complexityFactor = complexityFactor * (1 + symbolDensity)
	end

	-- Check for potential code or JSON
	if text:match("^%s*[{%[]") and text:match("[}%]]%s*$") then
		complexityFactor = complexityFactor * 1.2
	elseif text:match("function%s+%w+%(") or text:match("for%s+%w+%s*=") then
		complexityFactor = complexityFactor * 1.3
	end

	local baseReadingSpeed = 400 -- words per minute
	local adjustedReadingSpeed = baseReadingSpeed / complexityFactor
	local minutesToRead = wordCount / adjustedReadingSpeed
	local millisecondsToRead = minutesToRead * 60 * 1000

	return math.floor(millisecondsToRead)
end

local function estimateReadingTime(text)
	local words = {}
	for word in text:gmatch("%S+") do
		table.insert(words, word)
	end

	local wordCount = #words
	local averageReadingSpeed = 200 -- words per minute
	local minutesToRead = wordCount / averageReadingSpeed
	local millisecondsToRead = minutesToRead * 60 * 1000

	return math.floor(millisecondsToRead)
end

---@class notify.Record
--- Record of a previously sent notification
---@field id integer
---@field message string[] Lines of the message
---@field level string|integer Log level. See vim.log.levels
---@field title string[] Left and right sections of the title
---@field icon string Icon used for notification
---@field time number Time of message, as returned by `vim.fn.localtime()`
---@field render function Function to render notification buffer

---@class notify.Notification
---@field id integer
---@field level string
---@field message string[]
---@field timeout number | (fun(self:notify.Notification):number) | nil
---@field title string[]
---@field icon string
---@field time number
---@field width number
---@field animate boolean
---@field hide_from_history boolean
---@field keep fun(): boolean
---@field on_open fun(win: number, record: notify.Record) | nil
---@field on_close fun(win: number, record: notify.Record) | nil
---@field render fun(buf: integer, notification: notify.Notification, highlights: table<string, string>)

---@param notification notify.Notification
local function calculateTimeout(notification)
	local allText = table.concat(notification.title) .. " " .. table.concat(notification.message)
	local estimatedMs = estimateAdvancedReadingTime(allText)
	return estimatedMs
end

return {
	-- "rcarriga/nvim-notify",
	"adamtajti/nvim-notify",
	-- dir = "/home/adamtajti/GitHub/adamtajti/nvim-notify",
	--branch = "master",
	branch = "timeout-function",
	name = "notify",
	event = "VeryLazy",
	opts = {
		--background_colour = "NotifyBackground",
		-- background_colour = "#000000",
		stages = "static",
		timeout = calculateTimeout,
		fps = 144,
		top_down = true,
		render = "wrapped-compact",
	},
}
