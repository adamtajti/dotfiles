return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  name = "null-ls",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },

  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      root_dir = require("null-ls.utils").root_pattern(
        ".null-ls-root",
        ".neoconf.json",
        "Makefile",
        ".git"
      ),
      log_level = "debug",
      sources = {

        -- stylua is a formatter for LUA files
        null_ls.builtins.formatting.stylua,

        -- fixjson is a formatter for JSON files
        -- disabled for testing deno_fmt
        -- deprecated builtin, which will be removed in March 2024
        -- null_ls.builtins.formatting.fixjson,

        -- C/C++/C# formatter
        null_ls.builtins.formatting.uncrustify,

        -- gofmt is a formatter Go files
        null_ls.builtins.formatting.gofmt,

        -- Ruby
        null_ls.builtins.formatting.rubocop,

        -- goimports is a formatter Go files to remove unused imports and add missing ones
        null_ls.builtins.formatting.goimports.with({
          generator_opts = {
            args = {
              "-srcdir",
              "$DIRNAME",
              "--local",
              "tulip/",
            },
          },
        }),

        -- goimports_reviser is a formatter Go files to sort goimports by 3 groups: std, general and project dependencies
        null_ls.builtins.formatting.goimports_reviser.with({
          generator_opts = {
            args = {
              "$FILENAME",
              "-company-prefixes",
              "tulip/",
              "--imports-order",
              "std,company,project,general",
            },
          },
        }),

        -- alejandra is a formatter for Nix files
        -- null_ls.builtins.formatting.alejandra,

        -- yamlfmt is a formatter for YAML files from Google in Go
        -- https://github.com/google/yamlfmt/blob/main/docs/config-file.md
        -- null_ls.builtins.formatting.yamlfmt,

        -- jq is a formetter for JSON files
        -- null_ls.builtins.formatting.jq,

        -- rome is a formatter for JS/TS/JSON/HTML/Markdown/CSS files
        -- null_ls.builtins.formatting.rome.with({
        -- 	"json",
        -- }),

        -- prettierd is a daemon optimized formatter for JS/TS files
        null_ls.builtins.formatting.prettierd.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            -- "yaml",
            "markdown",
            "markdown.mdx",
            "graphql",
            "handlebars",
          },
        }),

        -- beautysh is a formatter for sh, Bash, ZSH files
        -- null_ls.builtins.formatting.beatysh,

        -- rubyfmt is a formatter for ruby files
        -- disabled this as it seems to be incompatible with florist / tulip projects
        --null_ls.builtins.formatting.rubyfmt,

        -- deno_fmt is a formatter for Markdown,JSON,JSONC files
        -- null_ls.builtins.formatting.deno_fmt.with({
        -- 	filetypes = { "json", "jsonc" },
        -- }),
        -- null_ls.builtins.formatting.json_tool.with({
        -- 	filetypes = { "json", "jsonc" },
        -- }),

        -- djlint is a formatter for HTML files
        -- null_ls.builtins.formatting.djlint,

        -- terraform formatter in markdown files
        -- deprecated builtin, which will be removed in March 2024
        -- null_ls.builtins.formatting.terrafmt,

        -- terraform formatter
        null_ls.builtins.formatting.terraform_fmt,

        -- shell formatter
        null_ls.builtins.formatting.shfmt,

        -- markdownlint provides diagnostics for Markdown files
        null_ls.builtins.diagnostics.markdownlint,

        -- eslint_d provides diagnostics for JS/TS files
        -- null_ls.builtins.diagnostics.eslint,
        -- eslint has been depracated in favor of the native eslint language server, which is in a none-ls extra package.
        -- require("none-ls.diagnostics.eslint-language-server"),
        require("none-ls.diagnostics.eslint_d"),

        -- terraform diagnostics
        null_ls.builtins.diagnostics.terraform_validate,

        -- printenv is a hover tool to show what the current values of the env variables are
        null_ls.builtins.hover.printenv,
      },
    })

    require("mason-null-ls").setup({
      ensure_installed = nil,
      automatic_installation = true,
    })
  end,
}
