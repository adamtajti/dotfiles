--- moonfly is a dark charcoal theme for modern Neovim and classic Vim.
--- https://github.com/bluz71/vim-moonfly-colors
return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true
    vim.g.moonflyNormalFloat = true
    vim.g.moonflyVirtualTextColor = true
    vim.g.moonflyUndercurls = true
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
    }

    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#080808", bg = "#080808" })

    -- toggle them with :GitSigns toggle_linehl
    vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#080808" })
    vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#080808" })

    local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "moonfly",
      callback = function()
        vim.api.nvim_set_hl(0, "MoonflyVisual", { bg = "#121212" })
        vim.api.nvim_set_hl(
          0,
          "ErrorMsg",
          { bg = "#000000", fg = "#ff5454", bold = true }
        )

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

        vim.api.nvim_set_hl(0, "MatchParen", { bg = "#121212", bold = true })
        vim.api.nvim_set_hl(0, "Function", { fg = "#74b2ff", bold = true })
        vim.api.nvim_set_hl(0, "PreProc", { fg = "#36c692" })
        vim.api.nvim_set_hl(0, "String", { fg = "#85dc85" })
        vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#C2DDFF" })
        vim.api.nvim_set_hl(
          0,
          "LspInlayHint",
          { bg = "#0A0A0A", fg = "#4e4e4e" }
        )

        vim.api.nvim_set_hl(0, "Search", { bg = "#121212", fg = "#e3c78a" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#79dac8", fg = "#080808" })
        vim.api.nvim_set_hl(0, "CurSearch", { bg = "#79dac8", fg = "#080808" })

        vim.api.nvim_set_hl(0, "DiffAdd", { bg = "NONE", fg = "#00875f" })
        vim.api.nvim_set_hl(0, "DiffChange", { bg = "NONE", fg = "#79dac8" })
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "NONE", fg = "#DC143C" })
        vim.api.nvim_set_hl(0, "DiffText", { bg = "NONE", fg = "#4d5d8d" })
        -- vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#00875f", fg = "#e4e4e4" })
        -- vim.api.nvim_set_hl(0, "DiffChange", { bg = "#79dac8", fg = "#080808" })
        -- vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#DC143C", fg = "#e4e4e4" })
        -- vim.api.nvim_set_hl(0, "DiffText", { bg = "#4d5d8d" })

        vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#79dac8" })
      end,
      group = custom_highlight,
    })

    vim.cmd.colorscheme("moonfly")
  end,
}
