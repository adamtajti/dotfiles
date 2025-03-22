local lazy_plugin_config = require("plugins.config")

local customization = {
  -- possible modes:
  -- - copilot
  -- - snippets
  mode = "none",
}

local reset_mode = function() customization.mode = "none" end

local toggle_mode = function(mode)
  customization.mode = (customization.mode == mode) and "none" or mode

  -- This should be only invoked when the snippets change. An improvement could
  -- be to setup file watchers again.
  local blink_snippets = require("blink.cmp.sources.snippets.default")
  blink_snippets:reload()

  local blink = require("blink.cmp")
  if blink.is_visible() then
    blink.cancel({
      callback = function() blink.show({ providers = { mode } }) end,
    })
  else
    blink.show({ providers = { mode } })
  end
end

-- Reset to none when leaving insert mode
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = reset_mode,
})

return {
  "saghen/blink.cmp",
  -- lazy = false, -- lazy loading handled internally
  enabled = lazy_plugin_config.blink_instead_of_cmp,
  dependencies = {
    -- optional: provides snippets for the snippet source
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
  },

  -- use a release tag to download pre-built binaries
  version = "v0.14.0",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  keys = {
    {
      "<C-.>",
      mode = "i",
      function() toggle_mode("snippets") end,
      desc = "blink.cmp: toggle snippets mode",
      noremap = true,
    },
    {
      "<C-,>",
      mode = "i",
      function() toggle_mode("copilot") end,
      desc = "blink.cmp: toggle copilot mode",
      noremap = true,
    },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      completion = {
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ":"
            -- enable for inputs as well, with:
            -- or vim.fn.getcmdtype() == '@'
          end,
        },
      },
      keymap = {
        ["<Tab>"] = { "show", "accept", "fallback" },
        -- ["<CR>"] = { "accept_and_enter", "fallback" },
        ["<C-o>"] = { "accept_and_enter", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-l>"] = { "accept", "fallback" },
        ["<C-;>"] = { "show", "show_documentation", "hide_documentation" },
      },
    },

    keymap = {
      ["<C-;>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "cancel", reset_mode, "fallback" },
      ["<C-l>"] = { "accept", reset_mode },
      ["<C-k>"] = { "select_prev" },
      ["<C-j>"] = { "select_next" },
      ["<C-b>"] = { "scroll_documentation_up" },
      ["<C-f>"] = { "scroll_documentation_down" },
      ["<C-n>"] = { "snippet_forward", "fallback" },
      ["<C-p>"] = { "snippet_backward", "fallback" },
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      -- I tested all of these variations:
      -- I don't actually use the config this way, but I left it here, cause I
      -- recently did some blink related development with source injections
      -- per_filetype = {
      --   ["markdown"] = function()
      --     return { "copilot", "lsp", "snippets", "path" }
      --   end,
      --
      --   ["markdown"] = { "copilot", "lsp", "snippets", "path" },
      -- },
      -- default = { "copilot", "lsp", "snippets", "path" },
      default = function()
        -- I configured some keymaps to add custom modes which corresponds to
        -- blink source names. This allows me to use these noisy sources only
        -- when I intend to use them
        if customization.mode ~= "none" then
          return { customization.mode }
        end

        -- Use :InspectTree to figure out the node types
        local success, node = pcall(vim.treesitter.get_node)
        if
          success
          and node
          and vim.tbl_contains(
            { "comment", "line_comment", "block_comment" },
            node:type()
          )
        then
          return { "path" }
        end

        local sources = { "lsp", "path" }

        if vim.bo.filetype == "lua" then
          table.insert(sources, 1, "lazydev")
        end

        return sources
      end,
      -- NOTE: obsidian.nvim is dynamically configured, which is why it's not
      -- present neither among the providers nor among the sources.
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- top priority
        },
        snippets = {
          -- should_show_items = function(ctx)
          --   return ctx.trigger.initial_kind ~= "trigger_character"
          -- end,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 3,
            max_attempts = 4,
          },
        },
      },
    },

    completion = {
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        range = "full",
      },
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 50 },
      ghost_text = {
        enabled = false,
      },
      menu = {
        border = "rounded",
        draw = {
          treesitter = {
            "lsp",
          },
          columns = {
            { "kind_icon", "label", "label_description", gap = 2 },
          },
        },
      },
    },
    signature = { enabled = true },
  },

  -- allows extending the enabled_providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.completion.enabled_providers" },
}
