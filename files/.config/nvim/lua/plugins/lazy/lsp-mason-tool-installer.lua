return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  event = "VeryLazy",
  opts = {
    -- These are mason-lspconfig specific server names. Many of the none-ls / null-ls servers are not listed here.
    -- /home/adamtajti/.local/share/nvim/lazy/mason-lspconfig.nvim/doc/server-mapping.md
    ensure_installed = {
      -- clangd understands your C++ code and adds smart features to your editor: code completion, compile errors, go-to-definition and more.
      "clangd",
      -- OmniSharp language server based on Roslyn workspaces. This version of Omnisharp requires dotnet (.NET 6.0) to be installed.
      "omnisharp",
      -- Static type checker for Python.
      "pyright",
      -- Black, the uncompromising Python code formatter.
      "black",
      -- isort your imports, so you don't have to.
      "isort",
      -- Solargraph is a Ruby gem that provides intellisense features through the language server protocol.
      "solargraph",
      -- rust-analyzer is an implementation of the Language Server Protocol for the Rust programming language. It provides features like completion and goto definition for many code editors, including VS Code, Emacs and Vim.
      "rust-analyzer",
      -- Language Server Protocol implementation for JSON.
      "json-lsp",
      -- An opinionated Lua code formatter.
      "stylua",
      -- Prettier, as a daemon, for ludicrous formatting speed.
      "prettierd",
      -- Java language server.
      "jdtls",
      -- yamlfmt is an extensible command line tool or library to format yaml files.
      "yamlfmt",
      -- A tool for linting and static analysis of Lua code.
      "luacheck",
      -- Makes eslint the fastest linter on the planet.
      "eslint_d",
      -- ShellCheck, a static analysis tool for shell scripts.
      "shellcheck",
      -- A shell formatter (sh/bash/mksh).
      "shfmt",
      -- A JSON file fixer/formatter for humans using (relaxed) JSON5.
      "fixjson",
      -- Language Server Protocol implementation for HTML.
      "html-lsp",
      -- A language server for Bash.
      "bash-language-server",
      -- "typescript-language-server", or just "tsserver"
      "typescript-language-server",
      -- VSCode's LSP compliant alternative to "tsserver"
      "vtsls",
      -- A language server that offers Lua language support - programmed in Lua.
      "lua-language-server",
      -- A language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies.
      "dockerfile-language-server",
      -- A language server for Docker Compose.
      "docker-compose-language-service",
      -- Language Server for YAML Files.
      "yaml-language-server",
      -- Terraform Language Server.
      "terraform-ls",
      -- A Pluggable Terraform Linter.
      "tflint",
      -- HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang.
      "djlint",
      -- A golang formatter which formats your code in the same style as gofmt and additionally updates your Go import lines, adding missing ones and removing unreferenced ones.
      "goimports",
      -- Tool for Golang to sort goimports by 3-4 groups: std, general, company (optional), and project dependencies. Also, formatting for your code will be prepared (so, you don't need to use gofmt or goimports separately). Use additional option -rm-unused to remove unused imports and -set-alias to rewrite import aliases for versioned packages.
      "goimports-reviser",
      -- A golang formatter that fixes long lines.
      "golines",
      -- Go tool to modify/update field tags in structs.
      "gomodifytags",
      -- golangci-lint is a fast Go linters runner. It runs linters in parallel, uses caching, supports yaml config, has integrations with all major IDE and has dozens of linters included.
      "golangci-lint",
      -- Delve is a debugger for the Go programming language.
      "delve",
      -- Prettier, as a daemon, for ludicrous formatting speed.
      "prettierd",
      -- The Ruby Linter/Formatter that Serves and Protects.
      "rubocop",
      -- C/C++
      "clang-format",
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 0,
    debounce_hourse = 5,
  },
  config = function(_, opts)
    require("mason-tool-installer").setup(opts)

    vim.api.nvim_command("MasonToolsInstall")
  end,
}