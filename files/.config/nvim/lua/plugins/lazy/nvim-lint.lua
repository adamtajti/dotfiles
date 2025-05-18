return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      vue = { "eslint_d" },
      python = { "pylint" },
      ["yaml.ghaction"] = { "actionlint" },
      ["yaml.ansible"] = { "ansible-lint" },
      rust = { "clippy" },
    }

    vim.keymap.set(
      "n",
      "<leader>lL",
      function() lint.try_lint() end,
      { desc = "Lint" }
    )

    local util = require("lspconfig.util")
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      callback = function(args)
        require("lint").try_lint(nil, {
          cwd = util.root_pattern({ ".eslintrc.json", "package.json", ".git" })(
            args.file
          ),
        })
      end,
    })
  end,
}
