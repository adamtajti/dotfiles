-- Tree-sitter is an incremental syntax tree builder plugin
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "master", -- main is the most up-to-date
  -- branch = "master", -- this seems to be the stable branch if main breaks
  lazy = false,
  opts = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "gitignore",
        "gitcommit",
        "go",
        "gomod",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "ninja",
        "nix",
        "php",
        "proto",
        "python",
        "query",
        "regex",
        "ruby",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "terraform",
        "scss",
        "ini",
        "angular",
        "awk",
        "comment",
        "disassembly",
        "doxygen",
        "erlang",
        "glsl",
        "gosum",
        "gowork",
        "graphql",
        "haskell",
        "hlsl",
        "hyprlang",
        "java",
        "luadoc",
        "muttrc",
        "requirements",
        "tsv",
        "xml",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      auto_install = true,

      -- Please the LSP, doesn't really gets mentioned in the docs.
      modules = {},

      -- List of parsers to ignore installing
      ignore_install = {},

      -- Modules
      incremental_selection = { enable = true },

      indent = {
        enable = true,
        disable = { "yaml" },
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = function(lang, bufnr)
          if lang == "cpp" then
            return vim.api.nvim_buf_line_count(bufnr) > 50000
          elseif lang == "json" then
            return vim.api.nvim_buf_line_count(bufnr) > 50000
          elseif lang == "make" then
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end

          return false
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },

        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },

        lsp_interop = {
          enable = false,
          peek_definition_code = {
            ["gD"] = "@function.outer",
          },
        },
      },
    })
  end,
}
