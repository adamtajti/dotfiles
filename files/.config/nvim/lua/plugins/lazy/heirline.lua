local heirline_filepath_plugin = require("plugins.lazy.heirline.filepath")

return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    -- 
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local black = "#000000"

    local SeperatorFn = function(text, color)
      return {
        provider = function(_self) return text end,
        hl = { fg = color },
      }
    end

    local RightSeperatorFn = function(color) return SeperatorFn(" ", color) end
    local LeftSeperatorFn = function(color) return SeperatorFn(" ", color) end

    local FileNameBlock = {
      init = function(self)
        -- local filename = vim.api.nvim_buf_get_name(0)
        --
        -- if not conditions.width_percent_below(#filename, 0.25) then
        --   filename = vim.fn.pathshorten(filename, 2)
        -- end

        local filename = heirline_filepath_plugin.format_buffer_path(0)
        self.filename = filename
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename

        if vim.bo[0].filetype == "oil" then
          local mini_icons = require("mini.icons")
          local oil = require("oil")

          local current_dir = oil.get_current_dir(0)
          local icon_highlight_group = ""
          self.icon, icon_highlight_group =
            mini_icons.get("directory", current_dir)

          local hl_group_info = vim.api.nvim_get_hl(
            0,
            { name = icon_highlight_group, link = false, create = false }
          )

          self.icon_color = string.format("#%06x", hl_group_info.fg)

          return
        end

        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(
            filename,
            extension,
            { default = true }
          )
      end,
      provider = function(self) return self.icon and (" " .. self.icon .. " ") end,
      hl = function(self) return { fg = self.icon_color, bg = "#000000" } end,
    }

    local RightSeperator = {
      provider = function(_self) return " " end,
      hl = { fg = "#000000" },
    }

    local FileName = {
      provider = function(self)
        local filename = self.filename
        -- local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return ""
        end

        local taken_space_perc = #filename / vim.o.columns
        if taken_space_perc > 0.8 then
          return vim.fn.trim(filename, "", 1)
        end

        return filename
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
      {
        condition = function() return vim.bo.modified end,
        provider = " ",
        hl = { fg = "#f09479" },
      },
      {
        condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
        provider = " ",
        hl = { fg = "#ff5189" },
      },
    }

    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          return { fg = "#9e9e9e", bold = true, force = true }
        else
          return { fg = "#e4e4e4", bold = false, force = true }
        end
      end,
    }

    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_colors = {
          -- Update with colors from
          -- /home/adamtajti/.local/share/nvim/lazy/moonfly/lua/moonfly/init.lua
          -- n = "red",
          -- i = "green",
          -- v = "cyan",
          -- V = "cyan",
          -- ["\22"] = "cyan",
          -- c = "orange",
          -- s = "purple",
          -- S = "purple",
          -- ["\19"] = "purple",
          -- R = "orange",
          -- r = "orange",
          -- ["!"] = "red",
          -- t = "red",
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long.
      provider = function(self) return self.mode end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        local fg = self.mode_colors[mode]

        if fg == nil then
          fg = "#b2b2b2"
        end

        return { fg = fg, bg = "#121212", bold = false }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
      },
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      RightSeperatorFn(black),
      utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
      FileFlags,
      { provider = "%<" }
    )

    ViModeBlock = utils.insert(
      LeftSeperatorFn("#121212"),
      ViMode,
      RightSeperatorFn("#121212")
    )

    require("heirline").setup({
      ---@diagnostic disable-next-line: missing-fields eh
      statusline = {
        FileNameBlock,
        ViModeBlock,
      },
    })
  end,
}
