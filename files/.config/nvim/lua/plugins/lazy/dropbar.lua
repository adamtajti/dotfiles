--- A polished, IDE-like, highly-customizable winbar for Neovim
--- with drop-down menu support and multiple backends
--- https://github.com/Bekaboo/dropbar.nvim

---@type LazyPluginSpec
return {
  "Bekaboo/dropbar.nvim",
  lazy = false, -- Saved along with the session, it's best to set it up early
  enabled = true,
  -- event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  ---@type dropbar_configs_t?
  opts = {
    sources = {
      treesitter = {
        valid_types = {
          "array",
          "boolean",
          "break_statement",
          "call",
          "case_statement",
          "class",
          "constant",
          "constructor",
          "continue_statement",
          "delete",
          "do_statement",
          "element",
          "enum",
          "enum_member",
          "event",
          "for_statement",
          "function",
          "h1_marker",
          "h2_marker",
          "h3_marker",
          "h4_marker",
          "h5_marker",
          "h6_marker",
          "if_statement",
          "interface",
          "keyword",
          "macro",
          "method",
          "module",
          "namespace",
          "null",
          "number",
          "operator",
          "package",
          "pair",
          "property",
          "reference",
          "repeat",
          "rule_set",
          "scope",
          "specifier",
          "struct",
          "switch_statement",
          "type",
          "type_parameter",
          "unit",
          "value",
          "variable",
          "while_statement",
          "declaration",
          "field",
          "identifier",
          "object",
          "statement",
          "composite_literal",
          "keyed_element",
          "var_spec",
        },
      },
    },
    icons = {
      enable = true,
      ui = {
        bar = {
          separator = " ＞ ",
          extends = "…",
        },
        menu = {
          separator = " ",
          indicator = " ＞ ",
        },
      },
    },
    menu = {
      entry = {
        padding = {
          left = 1,
          right = 1,
        },
      },
    },
  },
  config = function(_, lazy_opts)
    require("dropbar").setup(lazy_opts)

    -- vim.api.nvim_set_hl(0, "DropBarIconKindArray", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindBoolean", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindBreakStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindCall", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindCaseStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindClass", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindConstant", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindConstructor", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindContinueStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindDeclaration", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindDelete", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindDoStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindElseStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindEnum", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindEnumMember", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindEnumMember", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindEvent", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindField", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindFile", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindFolder", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindForStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindFunction", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindIdentifier", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindIfStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindInterface", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindKeyword", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindList", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMacro", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH1", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH2", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH3", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH4", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH5", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMarkdownH6", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindMethod", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindModule", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindNamespace", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindNull", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindNumber", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindObject", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindOperator", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindPackage", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindProperty", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindReference", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindRepeat", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindScope", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindSpecifier", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindString", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindStruct", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindSwitchStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindType", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindTypeParameter", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindUnit", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindValue", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindVariable", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconKindWhileStatement", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconUIIndicator", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconUIPickPivot", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconUISeparator", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarIconUISeparatorMenu", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarMenuCurrentContext", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarMenuNormalFloat", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarMenuHoverEntry", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarMenuHoverIcon", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarMenuHoverSymbol", { bg = nil })
    -- vim.api.nvim_set_hl(0, "DropBarPreview", { bg = nil })
    vim.api.nvim_set_hl(0, "WinBar", { bg = nil })
  end,
}
