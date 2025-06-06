--- moonfly is a dark charcoal theme for modern Neovim and classic Vim.
--- https://github.com/bluz71/vim-moonfly-colors

local hl = vim.api.nvim_set_hl

return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  enabled = true,
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true
    vim.g.moonflyNormalFloat = true
    vim.g.moonflyVirtualTextColor = true
    vim.g.moonflyUndercurls = false
    vim.g.moonflyWinSeparator = 2
    vim.g.moonflyCursorColor = true

    vim.opt.fillchars = {
      horiz = "━",
      horizup = "┻",
      horizdown = "┳",
      vert = "┃",
      vertleft = "┫",
      vertright = "┣",
      verthoriz = "╋",
      foldclose = "",
      foldopen = "",
    }

    hl(0, "VertSplit", { fg = "#080808", bg = "#080808" })

    -- toggle them with :GitSigns toggle_linehl
    hl(0, "GitSignsAddLn", { bg = "#080808" })
    hl(0, "GitSignsChangeLn", { bg = "#080808" })

    local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "moonfly",
      callback = function()
        -- highlight(0, "MoonflyVisual", { bg = "#3a005f" })
        hl(0, "MoonflyVisual", { bg = "#373c4d" })

        hl(0, "ErrorMsg", { bg = "#000000", fg = "#ff5454", bold = true })

        -- colors to mod later
        -- highlight(0, "@markup.heading.1.markdown", { link = "MoonflyEmerald" })
        -- highlight(0, "@markup.heading.1.vimdoc", { link = "MoonflyBlue" })
        -- highlight(0, "@markup.heading.2.markdown", { link = "MoonflyLavender" })
        -- highlight(0, "@markup.heading.2.vimdoc", { link = "MoonflyBlue" })
        -- highlight(0, "@markup.heading.3.markdown", { link = "MoonflyTurquoise" })
        -- highlight(0, "@markup.heading.4.markdown", { link = "MoonflyOrange" })
        -- highlight(0, "@markup.heading.5.markdown", { link = "MoonflySky" })
        -- highlight(0, "@markup.heading.6.markdown", { link = "MoonflyViolet" })
        -- highlight(0, "@markup.heading.help", { link = "MoonflySky" })
        -- highlight(0, "@markup.heading.markdown", { link = "MoonflySky" })

        hl(0, "MatchParen", { bg = "#28282B", bold = true })
        hl(0, "Function", { fg = "#74b2ff", bold = true })
        -- if, else
        hl(0, "Statement", { fg = "#cf87e8", bold = true })
        hl(0, "PreProc", { fg = "#36c692" })
        hl(0, "String", { fg = "#85dc85" })
        hl(0, "@variable.parameter", { fg = "#C2DDFF" })
        hl(0, "LspInlayHint", { bg = "#0A0A0A", fg = "#4e4e4e" })

        hl(0, "Boolean", { link = "MoonflyEmerald" })
        hl(0, "Operator", { link = "MoonflyViolet" })

        hl(0, "Search", { bg = "#121212", fg = "#e3c78a" })
        hl(0, "IncSearch", { bg = "#79dac8", fg = "#080808" })
        hl(0, "CurSearch", { bg = "#79dac8", fg = "#080808" })

        hl(0, "DiffAdd", { bg = "NONE", fg = "#00875f" })
        hl(0, "DiffChange", { bg = "NONE", fg = "#79dac8" })
        hl(0, "DiffDelete", { bg = "NONE", fg = "#DC143C" })
        hl(0, "DiffText", { bg = "NONE", fg = "#4d5d8d" })
        -- highlight(0, "DiffAdd", { bg = "#00875f", fg = "#e4e4e4" })
        -- highlight(0, "DiffChange", { bg = "#79dac8", fg = "#080808" })
        -- highlight(0, "DiffDelete", { bg = "#DC143C", fg = "#e4e4e4" })
        -- highlight(0, "DiffText", { bg = "#4d5d8d" })

        hl(0, "TelescopeMatching", { fg = "#79dac8" })

        -- Other background color could be #121212
        hl(0, "NuiComponentsButton", { fg = "#e4e4e4", bg = "#1c1c1c" })

        hl(0, "NuiComponentsButtonFocused", { fg = "#080808", bg = "#36c692" })

        hl(
          0,
          "NuiComponentsSelectOptionSelected",
          { fg = "#080808", bg = "#36c692" }
        )

        hl(0, "MoonflyEmeraldCursor", { bg = "#36c692" })
        hl(0, "MoonflyLavenderCursor", { bg = "#adadf3" })
        hl(0, "MoonflyVioletCursor", { bg = "#cf87e8" })

        hl(0, "StatusLine", { bg = "#0a0a0a", fg = "#c6c6c6" })
        hl(0, "StatusLineNC", { bg = "#0a0a0a", fg = "#9e9e9e" })
        hl(0, "StatusLineTerm", { bg = "#000000", fg = "#c6c6c6" })
        hl(0, "StatusLineTermNC", { bg = "#0a0a0a", fg = "#9e9e9e" })

        hl(0, "DiagnosticVirtualTextError", { bg = "#000000", fg = "#ff5d5d" })
        hl(0, "DiagnosticVirtualTextWarn", { bg = "#000000", fg = "#e3c78a" })
        hl(0, "DiagnosticVirtualTextInfo", { bg = "#000000", fg = "#74b2ff" })
        hl(0, "DiagnosticVirtualTextHint", { bg = "#000000", fg = "#79dac8" })
        hl(0, "DiagnosticVirtualTextOk", { bg = "#000000", fg = "#36c692" })

        -- nvim-dap-virtual-text customization
        -- NvimDapVirtualTextChanged (links to DiagnosticVirtualTextWarn xxx guifg=#e3c78a guibg=#000000)
        -- NvimDapVirtualText xxx (links to Comment        xxx cterm=italic gui=italic guifg=#949494)
        hl(
          0,
          "NvimDapVirtualTextChanged",
          { fg = "#79dac8", bg = "#000000", italic = true }
        )
        hl(
          0,
          "NvimDapVirtualText",
          { fg = "#adadf3", bg = "#000000", italic = true }
        )
      end,
      group = custom_highlight,
    })

    vim.cmd.colorscheme("moonfly")
  end,
}
