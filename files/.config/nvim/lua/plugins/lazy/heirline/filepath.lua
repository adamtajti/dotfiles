-- nvim_buffer_path_formatter.lua

local M = {}

--- Configuration for the path formatter.
--- @class PathFormatterConfig
--- @field max_width number The maximum width of the truncated path.
--- @field get_acronym fun(dir_name: string): string A function to get the acronym for a directory name.
M.config = {
  max_width = 40, -- Default maximum width
  get_acronym = function(segment)
    -- If there are at least two characters and the segment starts with a . choose two characters at least
    if #segment > 1 and string.sub(segment, 1, 1) == "." then
      return string.sub(segment, 1, 2)
    end

    if segment == "npm" then
      return "npm"
    end

    if segment == "common" then
      return "common"
    end

    return string.sub(segment, 1, 1)
  end,
}

--- Configures the path formatter.
--- @param opts PathFormatterConfig Configuration options to merge.
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Helper function to get the home directory.
--- @return string The user's home directory path.
local function get_home_dir() return vim.env.HOME or vim.env.USERPROFILE end

--- Helper function to find the Git root directory for a given path.
--- @param path string The path to check.
--- @return string|nil The Git root directory, or nil if not in a Git repo.
local function find_git_root(path)
  if not path then
    return nil
  end
  local current_dir = vim.fn.fnamemodify(path, ":h")
  while
    current_dir ~= ""
    and current_dir ~= "/"
    and current_dir ~= get_home_dir()
  do
    if vim.fn.isdirectory(current_dir .. "/.git") == 1 then
      return current_dir
    end
    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
    if parent_dir == current_dir then -- Reached root or invalid path
      break
    end
    current_dir = parent_dir
  end
  return nil
end

--- Transforms and truncates a buffer path based on specified rules.
--- @param bufnr number|nil The buffer number. If nil, uses the current buffer.
--- @return string The transformed and truncated path.
function M.format_buffer_path(bufnr)
  local buf_path = vim.api.nvim_buf_get_name(bufnr or 0)
  if buf_path == "" then
    return ""
  end

  local home_dir = get_home_dir()

  -- Rule: If the path starts with oil://, cut that
  if vim.startswith(buf_path, "oil://") then
    buf_path = string.sub(buf_path, 7)
  end

  local display_path = buf_path

  local git_root = find_git_root(buf_path)
  local filename = vim.fn.fnamemodify(buf_path, ":t")
  local parent_dir =
    vim.fn.fnamemodify(vim.fn.fnamemodify(buf_path, ":h"), ":t")

  -- Rule: Absolute path if not inside a git repository (vim.api.nvim_buf_get_name already returns absolute path)
  -- This is generally handled by nvim_buf_get_name, but we ensure it's absolute.
  if
    not vim.startswith(display_path, "/")
    and not vim.startswith(display_path, home_dir)
  then
    display_path = vim.fn.fnamemodify(display_path, ":p")
  end

  -- Rule: If inside a git repository, remove the path matching to the git root.
  if git_root then
    -- Ensure git_root ends with a separator for correct replacement
    local git_root_with_sep = git_root
    -- Changed vim.fn.pathsep to "/"
    if not vim.endswith(git_root_with_sep, "/") then
      git_root_with_sep = git_root_with_sep .. "/"
    end
    display_path =
      string.gsub(display_path, "^" .. vim.pesc(git_root_with_sep), "")
    -- If the path became empty (e.g., it was the git root itself), show the project name
    if display_path == "" then
      -- Changed vim.fn.pathsep to "/"
      display_path = vim.fn.fnamemodify(git_root, ":t") .. "/"
    end
  end

  -- Rule: If the absolute path is inside the home directory, replace with `~`.
  if vim.startswith(display_path, home_dir) then
    display_path = "~" .. string.sub(display_path, #home_dir + 1)
  end

  -- Rule: Truncation
  local parts = vim.split(display_path, "[/\\]") -- Split by / or \
  local truncated_parts = {}
  local current_len = 0

  if #parts <= 1 then
    return display_path
  end

  -- Checks if the last_part is an empty string, which signals that this path is to a folder, as it
  -- ended in /. e.g.: /usr/bin/
  local last_part = parts[#parts]
  local is_folder = last_part == ""
  if is_folder then
    table.remove(parts, #parts)
  end

  local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
  local root_dir_abs_path = nil
  for _, lsp_client in ipairs(lsp_clients) do
    -- naive way to fetch the lsp root path; i should look into capabilities or define explicitly what lsp client im
    -- interested in for each language
    root_dir_abs_path = lsp_client.root_dir
    break
  end

  local root_dir = nil
  if root_dir_abs_path ~= nil then
    root_dir = vim.fn.fnamemodify(root_dir_abs_path, ":t")
  end

  for i = #parts, 1, -1 do
    local truncated_part = parts[i]
    if i == #parts or i == #parts - 1 then
      -- noop, the last two segments are kept intact
    elseif i == 1 then
      -- noop, the very first path isn't truncated either
    elseif root_dir ~= nil and root_dir == parts[i] then
      -- noop, keep the root project dir name intact
    else
      truncated_part = M.config.get_acronym(truncated_part)
    end

    parts[i] = truncated_part
  end

  display_path = vim.fn.join(parts, "/")
  if is_folder then
    display_path = display_path .. "/"
  end

  -- msg = "root dir: " .. vim.inspect(root_dir)
  -- vim.notify(msg, vim.log.levels.WARN, {
  --   title = "heirline debugging",
  --   id = msg,
  -- })
  return display_path
end

return M
