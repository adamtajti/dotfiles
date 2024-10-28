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
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "eslint_d", "prettierd" },
      javascriptreact = { "eslint_d", "prettierd" },
      ["javascript.jsx"] = { "eslint_d", "prettierd" },
      typescript = { "eslint_d", "prettierd" },
      typescriptreact = { "eslint_d", "prettierd" },
      ["typescript.jsx"] = { "eslint_d", "prettierd" },
      ruby = { "rubocop" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      go = { "goimports", "goimports-reviser", "gofmt" },
      yaml = { "yamlfmt" },
      terraform = { "terraform_fmt" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      json = { "fixjson", "prettierd" },
      jsonc = { "fixjson", "prettierd" },
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
