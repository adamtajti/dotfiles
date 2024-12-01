local utils = require("deus.utils")

local M = {}

function M.selection_to_vscode_snippet(id, description, string_array)
  local snippet = '  "' .. id .. '": {\n'
  snippet = snippet .. '    "prefix": ["' .. id .. '"],\n'
  snippet = snippet .. '    "body": [\n'

  for _, entry in ipairs(string_array) do
    local escaped_entry = entry:gsub("\\", "\\\\")
    print(escaped_entry)
    escaped_entry = escaped_entry:gsub('"', '\\"')
    print(escaped_entry)
    escaped_entry = escaped_entry:gsub("%$", "\\\\$")
    print(escaped_entry)
    snippet = snippet .. '      "' .. escaped_entry .. '",\n'
  end

  snippet = snippet .. "    ]\n"
  snippet = snippet .. "  }\n"
  return snippet
end

-- @deprecated
function M.selection_to_lua_snippet(id, description, string_array)
  local snippet = "s('p-" .. id .. "', {\n"

  for _, entry in ipairs(string_array) do
    local escaped_entry = entry:gsub('"', '\\"')
    snippet = snippet .. '\tt({"' .. escaped_entry .. '", ""}),\n'
  end

  snippet = snippet .. "}),"
  return snippet
end

function M.setup()
  vim.api.nvim_set_keymap("n", "<Leader>Ds", "", {
    noremap = true,
    desc = "Syncs the system using dotfiles scripts",
    callback = function() vim.cmd("!~/GitHub/dotfiles/sync.sh") end,
  })

  vim.api.nvim_set_keymap("v", "<Leader>Ss", "", {
    desc = "Copy to Clipboard as a VSCode snippet",
    noremap = true,
    silent = true,
    callback = function()
      -- Get content from visual selection
      local lines = utils.get_visual_selection()
      local content = utils.ensure_string_array(lines)

      local snippet = M.selection_to_vscode_snippet(
        "first-snippet-test-without-id",
        "First Snippet Test Without ID",
        content
      )

      utils.copy_to_clipboard(snippet)
    end,
  })

  vim.api.nvim_set_keymap("n", "<Leader>So", "", {
    desc = "Open JSON settings for the active file type in VSCode",
    noremap = true,
    silent = true,
    callback = function()
      vim.cmd("vsplit")
      local filetype = vim.o.filetype

      local global_filetypes = { "plaintext", "text", "global", "all" }
      for _, ft in pairs(global_filetypes) do
        if ft == filetype then
          vim.cmd(
            "e "
              .. vim.fn.stdpath("config")
              .. "/snippets/snippets/"
              .. "global.json"
          )
          return
        end
      end

      local resolved_filetype = filetype

      local shell_filetypes = {
        "shellscript",
        "shell",
        "sh",
        "zsh",
        "bash",
      }
      for _, ft in pairs(shell_filetypes) do
        if ft == filetype then
          resolved_filetype = "shell"
          break
        end
      end

      local yaml_filetypes = {
        "yaml",
        "yml",
      }
      for _, ft in pairs(yaml_filetypes) do
        if ft == filetype then
          resolved_filetype = "yaml"
          break
        end
      end

      local typescript_filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      }
      for _, ft in pairs(typescript_filetypes) do
        if ft == filetype then
          resolved_filetype = "typescript"
          break
        end
      end

      vim.cmd(
        "e "
          .. vim.fn.stdpath("config")
          .. "/snippets/snippets/"
          .. resolved_filetype
          .. "/"
          .. resolved_filetype
          .. ".json"
      )
    end,
  })
end

return M
