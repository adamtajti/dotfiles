return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  tag = "v0.8.2",
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    -- v0.8.2: keymaps should be fine
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
        else
          return { "lazydev", "snippets", "lsp", "path" }
        end
      end,
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
      },
    },

    completion = {
      ghost_text = {
        enabled = true,
      },
      documentation = { auto_show = true, auto_show_delay_ms = 50 },
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before *and* after the cursor
        range = "full",
        -- Regex used to get the text when fuzzy matching
        regex = "[-_]\\|\\k",
        -- After matching with regex, any characters matching this regex at the prefix will be excluded
        exclude_from_prefix_regex = "[\\-]",
      },
      accept = { auto_brackets = { enabled = true } },
      menu = {
        border = "rounded",
        draw = {
          treesitter = {
            "lsp",
          },
          columns = {
            { "kind_icon", gap = 1 },
            { "label", "label_description", gap = 1 },
          },
        },
      },
    },

    signature = { enabled = true },

    -- trigger = {
    --   completion = {
    --     -- 'prefix' will fuzzy match on the text before the cursor
    --     -- 'full' will fuzzy match on the text before *and* after the cursor
    --     -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
    --     keyword_range = "prefix",
    --     -- regex used to get the text when fuzzy matching
    --     -- changing this may break some sources, so please report if you run into issues
    --     -- TODO: shouldnt this also affect the accept command? should this also be per language?
    --     keyword_regex = "[%w_\\-]",
    --     -- after matching with keyword_regex, any characters matching this regex at the prefix will be excluded
    --     exclude_from_prefix_regex = "[\\-]",
    --     -- LSPs can indicate when to show the completion window via trigger characters
    --     -- however, some LSPs (*cough* tsserver *cough*) return characters that would essentially
    --     -- always show the window. We block these by default
    --     blocked_trigger_characters = { " ", "\n", "\t" },
    --     -- when true, will show the completion window when the cursor comes after a trigger character after accepting an item
    --     show_on_accept_on_trigger_character = true,
    --     -- when true, will show the completion window when the cursor comes after a trigger character when entering insert mode
    --     show_on_insert_on_trigger_character = true,
    --     -- list of additional trigger characters that won't trigger the completion window when the cursor comes after a trigger character when entering insert mode/accepting an item
    --     show_on_x_blocked_trigger_characters = { "'", '"', "(" },
    --     -- when false, will not show the completion window when in a snippet
    --     show_in_snippet = true,
    --   },
    --
    --   signature_help = {
    --     enabled = true,
    --     blocked_trigger_characters = {},
    --     blocked_retrigger_characters = {},
    --     -- when true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
    --     show_on_insert_on_trigger_character = true,
    --   },
    -- },

    -- windows = {
    --   autocomplete = {
    --     min_width = 15,
    --     max_height = 10,
    --     border = "rounded",
    --     winblend = 0,
    --     winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
    --     -- keep the cursor X lines away from the top/bottom of the window
    --     scrolloff = 2,
    --     -- note that the gutter will be disabled when border ~= 'none'
    --     scrollbar = true,
    --     -- TODO: implement
    --     order = "top_down",
    --     -- which directions to show the window,
    --     -- falling back to the next direction when there's not enough space
    --     direction_priority = { "s", "n" },
    --     -- Controls whether the completion window will automatically show when typing
    --     auto_show = true,
    --     -- Controls how the completion items are selected
    --     -- 'preselect' will automatically select the first item in the completion list
    --     -- 'manual' will not select any item by default
    --     -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
    --     selection = "preselect",
    --     -- Controls how the completion items are rendered on the popup window
    --     draw = {
    --       -- Aligns the keyword you've typed to a component in the menu
    --       align_to_component = "label", -- or 'none' to disable
    --       -- Left and right padding, optionally { left, right } for different padding on each side
    --       padding = 1,
    --       -- Gap between columns
    --       gap = 1,
    --       -- Components to render, grouped by column
    --       columns = {
    --         { "kind_icon" },
    --         { "label", "label_description", gap = 1 },
    --       },
    --       -- Definitions for possible components to render. Each component defines:
    --       --   ellipsis: whether to add an ellipsis when truncating the text
    --       --   width: control the min, max and fill behavior of the component
    --       --   text function: will be called for each item
    --       --   highlight function: will be called only when the line appears on screen
    --       components = {
    --         kind_icon = {
    --           ellipsis = false,
    --           text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
    --           highlight = function(ctx)
    --             return require("blink.cmp.utils").get_tailwind_hl(ctx)
    --               or "BlinkCmpKind" .. ctx.kind
    --           end,
    --         },
    --
    --         kind = {
    --           ellipsis = false,
    --           width = { fill = true },
    --           text = function(ctx) return ctx.kind end,
    --           highlight = function(ctx)
    --             return require("blink.cmp.utils").get_tailwind_hl(ctx)
    --               or "BlinkCmpKind" .. ctx.kind
    --           end,
    --         },
    --
    --         label = {
    --           width = { fill = true, max = 60 },
    --           text = function(ctx) return ctx.label .. ctx.label_detail end,
    --           highlight = function(ctx)
    --             -- label and label details
    --             local label = ctx.label
    --             local highlights = {
    --               {
    --                 0,
    --                 #label,
    --                 group = ctx.deprecated and "BlinkCmpLabelDeprecated"
    --                   or "BlinkCmpLabel",
    --               },
    --             }
    --             if ctx.label_detail then
    --               table.insert(highlights, {
    --                 #label,
    --                 #label + #ctx.label_detail,
    --                 group = "BlinkCmpLabelDetail",
    --               })
    --             end
    --
    --             -- characters matched on the label by the fuzzy matcher
    --             for _, idx in ipairs(ctx.label_matched_indices) do
    --               table.insert(
    --                 highlights,
    --                 { idx, idx + 1, group = "BlinkCmpLabelMatch" }
    --               )
    --             end
    --
    --             return highlights
    --           end,
    --         },
    --
    --         label_description = {
    --           width = { max = 30 },
    --           text = function(ctx) return ctx.label_description end,
    --           highlight = "BlinkCmpLabelDescription",
    --         },
    --       },
    --     },
    --     -- Controls the cycling behavior when reaching the beginning or end of the completion list.
    --     cycle = {
    --       -- When `true`, calling `select_next` at the *bottom* of the completion list will select the *first* completion item.
    --       from_bottom = true,
    --       -- When `true`, calling `select_prev` at the *top* of the completion list will select the *last* completion item.
    --       from_top = true,
    --     },
    --   },
    --   documentation = {
    --     max_width = 80,
    --     max_height = 20,
    --     desired_min_width = 50,
    --     desired_min_height = 10,
    --     border = "rounded",
    --     winblend = 0,
    --     winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
    --     -- note that the gutter will be disabled when border ~= 'none'
    --     scrollbar = true,
    --     -- which directions to show the documentation window,
    --     -- for each of the possible autocomplete window directions,
    --     -- falling back to the next direction when there's not enough space
    --     direction_priority = {
    --       autocomplete_north = { "e", "w", "n", "s" },
    --       autocomplete_south = { "e", "w", "s", "n" },
    --     },
    --     -- Controls whether the documentation window will automatically show when selecting a completion item
    --     auto_show = true,
    --     auto_show_delay_ms = 50,
    --     update_delay_ms = 50,
    --     -- whether to use treesitter highlighting, disable if you run into performance issues
    --     -- WARN: temporary, eventually blink will support regex highlighting
    --     treesitter_highlighting = true,
    --   },
    --   signature_help = {
    --     min_width = 1,
    --     max_width = 100,
    --     max_height = 10,
    --     border = "rounded",
    --     winblend = 0,
    --     winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
    --     -- note that the gutter will be disabled when border ~= 'none'
    --     scrollbar = false,
    --
    --     -- which directions to show the window,
    --     -- falling back to the next direction when there's not enough space
    --     direction_priority = { "n", "s" },
    --     -- whether to use treesitter highlighting, disable if you run into performance issues
    --     -- WARN: temporary, eventually blink will support regex highlighting
    --     treesitter_highlighting = true,
    --   },
    --   ghost_text = {
    --     enabled = false,
    --   },
    -- },
  },
  -- allows extending the enabled_providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.completion.enabled_providers" },
}
