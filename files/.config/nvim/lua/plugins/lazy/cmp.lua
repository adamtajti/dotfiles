return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "onsails/lspkind.nvim",
    { "hrsh7th/cmp-nvim-lsp", lazy = false },
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
    "dmitmel/cmp-cmdline-history",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-omni",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "Dynge/gitmoji.nvim",

    -- I don't think I need this anymore
    -- "jmbuhr/otter.nvim",
  },
  opts = function()
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    local window_completion = cmp.config.window.bordered()
    window_completion.col_offset = -3

    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }

    cmp.setup({
      performance = {
        max_view_entries = 69,
        debounce = 250,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.locality,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.sort_text,
          cmp.config.compare.order,
        },
      },
      completion = {
        -- completeopt = "menu,menuone,noinsert,noselect",
        completeopt = "menu,noselect",
      },
      enabled = function() return true end,
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      window = {
        completion = window_completion,
        -- completion = cmp.config.window.bordered(),
        -- completion = {
        -- 	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        -- 	col_offset = -3,
        -- 	side_padding = 0,
        -- },
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        expandable_indicator = true,
        fields = {
          "abbr",
          "kind",
          "menu",
        },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind =
            string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
          -- Source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[LaTeX]",
          })[entry.source.name]
          return vim_item
        end,
      },
      mapping = {
        -- ["<C-k>"] = cmp.mapping.select_prev_item(),
        -- ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
          assert,
        }),
        ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end,
      },
      sources = cmp.config.sources({
        -- Lazydev lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
        { name = "lazydev", group_index = 0 },

        -- LSP completions
        { name = "nvim_lsp", group_index = 2 },

        -- Disabled for now. I think it was TMI
        --{ name = "treesitter" },

        -- nvim-cmp source for displaying function signatures with the current parameter emphasized:
        { name = "nvim_lsp_signature_help" },

        { name = "gitmoji" },
        {
          name = "omni",
          option = {
            disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
          },
        },

        { name = "emoji", option = { insert = true } },
        -- { name = "otter" },

        -- Snippets to keep us wet and DRY at the same time
        { name = "luasnip", max_view_entries = 3, group_index = 11 },
      }),
    })

    -- This doesn't work and I don't remember the syntax for safe requires
    -- I'll look into this the next time I configure copilot
    -- if vim.g.config.plugins.copilot.enable then
    -- 	table.insert(sources, { name = "copilot", group_index = 2 })
    -- end

    vim.api.nvim_set_keymap("i", "<C-x><C-o>", "", {
      desc = "nvim-cmp",
      noremap = true,
      callback = function() require("cmp").complete() end,
    })

    cmp.setup.filetype("NeogitCommitMessage", {
      sources = cmp.config.sources({
        { name = "gitmoji" },
      }),
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
        { name = "nvim_lsp_document_symbol" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- gray
    vim.api.nvim_set_hl(
      0,
      "CmpItemAbbrDeprecated",
      { bg = "NONE", strikethrough = true, fg = "#808080" }
    )
    -- blue
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
    vim.api.nvim_set_hl(
      0,
      "CmpItemAbbrMatchFuzzy",
      { link = "CmpIntemAbbrMatch" }
    )
    -- light blue
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindVariable",
      { bg = "NONE", fg = "#9CDCFE" }
    )
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindInterface",
      { link = "CmpItemKindVariable" }
    )
    vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
    -- pink
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindFunction",
      { bg = "NONE", fg = "#C586C0" }
    )
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindMethod",
      { link = "CmpItemKindFunction" }
    )
    -- front
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindKeyword",
      { bg = "NONE", fg = "#D4D4D4" }
    )
    vim.api.nvim_set_hl(
      0,
      "CmpItemKindProperty",
      { link = "CmpItemKindKeyword" }
    )
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
  end,
}
