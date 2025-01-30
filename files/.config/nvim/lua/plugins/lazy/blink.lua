return {
  "saghen/blink.cmp",
  -- lazy = false, -- lazy loading handled internally
  enabled = true,
  dependencies = {
    -- optional: provides snippets for the snippet source
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
  },

  -- use a release tag to download pre-built binaries
  version = "*",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ["<C-;>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<C-l>"] = { "accept" },

      ["<C-k>"] = { "select_prev" },
      ["<C-j>"] = { "select_next" },

      ["<C-b>"] = { "scroll_documentation_up" },
      ["<C-f>"] = { "scroll_documentation_down" },

      ["<C-n>"] = { "snippet_forward" },
      ["<C-p>"] = { "snippet_backward" },
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
          return { "snippets", "path" }
        end

        local sources = { "copilot", "lsp", "snippets", "path" }

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
      ghost_text = {
        enabled = true,
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },
      documentation = { auto_show = true, auto_show_delay_ms = 50 },
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        range = "full",
      },
      accept = { auto_brackets = { enabled = true } },
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
