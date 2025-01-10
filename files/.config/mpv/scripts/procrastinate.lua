-- based of https://raw.githubusercontent.com/stax76/mpv-scripts/refs/heads/main/history.lua
---@diagnostic disable: undefined-global -- mp globals are not detected

----- history
local time = 0 -- number of seconds since epoch
local currently_playing_file_path = ""

local o = {
  history_file_path = "~/.local/state/mpv/procastrinate-history.log",
  history_file_folder = "~/.local/state/mpv/",
  minimal_play_time = 60,
}

local opt = require("mp.options")
opt.read_options(o)

o.history_file_path = mp.command_native({ "expand-path", o.history_file_path })
o.history_file_folder =
  mp.command_native({ "expand-path", o.history_file_folder })

----- mpv

local msg = require("mp.msg")

----- string

local function is_empty(input)
  if input == nil or input == "" then
    return true
  end
end

local function contains(input, find)
  if not is_empty(input) and not is_empty(find) then
    return input:find(find, 1, true)
  end
end

----- math

local function round(value)
  return value >= 0 and math.floor(value + 0.5) or math.ceil(value - 0.5)
end

----- file

local function file_exists(file_path)
  local f = io.open(file_path, "r")

  if f ~= nil then
    io.close(f)
    return true
  end
end

local function file_must_exist()
  if not file_exists(o.history_file_path) then
    msg.info("Log file does not exist: " .. o.history_file_path)
    msg.info("Creating " .. o.history_file_path)
    os.execute("mkdir -p " .. o.history_file_folder)
    os.execute("touch " .. o.history_file_path)
  end
end

local function file_append(file_path, content)
  local h = assert(io.open(file_path, "ab"))
  h:write(content)
  h:close()
end

local function have_i_had_enough()
  file_must_exist()

  local h = assert(io.open(o.history_file_path, "r"))
  for c in h:lines() do
    msg.info("line: " .. c)
  end
  h:close()

  return false
end

----- history
local function history()
  local seconds = round(os.time() - time)

  file_must_exist()

  if
    not is_empty(currently_playing_file_path)
    and seconds > o.minimal_play_time
  then
    local line = os.date("%d.%m.%Y %H:%M ") .. seconds .. "\n"
    file_append(o.history_file_path, line)
  end

  currently_playing_file_path = mp.get_property("path")

  if contains(currently_playing_file_path, "://") then
    currently_playing_file_path = mp.get_property("media-title")
  end

  time = os.time()
end

local function enough_is_enough()
  mp.osd_message("there are other ways to regulate your emotions", 2)
  local overdosed = have_i_had_enough()

  if overdosed then
    mp.osd_message(
      "I should be doing something more useful with my time on this earth",
      30
    )
  end
end

mp.register_event("shutdown", history)
mp.register_event("file-loaded", history)
mp.register_event("file-loaded", enough_is_enough)
