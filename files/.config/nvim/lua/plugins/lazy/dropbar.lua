--- A polished, IDE-like, highly-customizable winbar for Neovim
--- with drop-down menu support and multiple backends
--- https://github.com/Bekaboo/dropbar.nvim

---@type LazyPluginSpec
return {
  "Bekaboo/dropbar.nvim",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  ---@type dropbar_configs_t?
  opts = {
    bar = {
      ---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
      sources = function(buf, _)
        local sources = require("dropbar.sources")
        if vim.bo[buf].ft == "markdown" then
          return {
            -- sources.path,
            sources.markdown,
          }
        end
        if vim.bo[buf].buftype == "terminal" then
          return {
            sources.terminal,
          }
        end
        return {
          -- sources.path,
          require("dropbar.utils").source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
      end,
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

    vim.api.nvim_set_hl(0, "WinBar", { bg = nil })
  end,
}
