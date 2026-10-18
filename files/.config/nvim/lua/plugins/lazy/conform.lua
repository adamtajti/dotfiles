---@type LazyPluginSpec
return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters = {
      goimports = {
        prepend_args = {
          "-srcdir",
          "$DIRNAME",
          "--local",
          "tulip/",
        },
      },
      fixjson = {
        prepend_args = {
          "-w",
        },
      },
      ["goimports-reviser"] = {
        prepend_args = {
          "$FILENAME",
          "-company-prefixes",
          "tulip/",
          "--imports-order",
          "std,company,project,general",
        },
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      -- 2026-08-06: Switched to ruff from black
      python = { "isort", "ruff" },
      rust = { "rustfmt", lsp_format = "fallback" },

      javascript = { "eslint_d", "prettierd" },
      javascriptreact = { "eslint_d", "prettierd" },
      ["javascript.jsx"] = { "eslint_d", "prettierd" },
      typescript = { "eslint_d", "prettierd" },
      typescriptreact = { "eslint_d", "prettierd" },
      ["typescript.jsx"] = { "eslint_d", "prettierd" },

      ruby = { "rubocop" },
      ["yaml.ghaction"] = { "yamlfmt" },
      yaml = { "yamlfmt" },

      -- Turned these off for now
      -- c = { "clang-format" },
      -- cpp = { "clang-format" },

      go = { "goimports", "goimports-reviser", "gofmt" },
      terraform = { "terraform_fmt" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      markdown = { "prettierd" },
      -- 2024-11-22: removed "fixjson" as it breaks tsconfig.references[]
      json = { "prettierd", lsp_format = "never" },
      -- 2024-11-22: removed "fixjson" as it breaks tsconfig.references[]
      jsonc = { "prettierd", lsp_format = "never" },
      css = { "prettierd", lsp_format = "never" },
      ["*"] = { "trim_whitespace" },
    },
    default_format_opts = {
      lsp_format = "fallback",
      timeout_ms = 15000,
      async = true,
    },
    format_after_save = {},
  },
}
