-- Gaps the bridge between mason and lspconfig
return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    {
      "yioneko/nvim-vtsls",
      optional = true,
    },
  },
  event = "VeryLazy",
  config = function()
    require("mason")
    require("mason-lspconfig").setup({})

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local on_attach = function(client, bufnr)
      vim.notify(
        "client: " .. vim.inspect(client) .. "bufnr: " .. vim.inspect(bufnr),
        vim.log.levels.TRACE,
        { title = "plugins/lsp-mason-lspconfig.lua" }
      )

      if client == nil or bufnr == nil then
        vim.notify(
          "on_attach called with nil client or bufnr",
          vim.log.levels.WARN,
          { title = "plugins/lsp-mason-lspconfig.lua" }
        )
        return
      end

      -- Disabled: TS io-ts has long and cryptic types
      -- vim.lsp.inlay_hint.enable()
    end

    require("mason-lspconfig").setup_handlers({
      -- default handler, called for installed servers without specific handlers
      function(server_name) -- default handler (optional)
        if server_name == "lua_ls" then
          vim.notify(
            "lua_ls load cancelled. Use folke/lazydev.nvim instead",
            vim.log.levels.DEBUG,
            { title = "plugins/lsp-mason-lspconfig.lua" }
          )
          return
        end

        if server_name == "ts_ls" then
          vim.notify(
            "ts_ls load cancelled. Use pmizio/typescript-tools.nvim instead",
            vim.log.levels.DEBUG,
            { title = "plugins/lsp-mason-lspconfig.lua" }
          )
          return
        end

        if server_name == "vtsls" then
          vim.notify(
            "vtsls load cancelled. Use yioneko/nvim-vtsls instead",
            vim.log.levels.DEBUG,
            { title = "plugins/lsp-mason-lspconfig.lua" }
          )
          return
        end

        require("lspconfig")[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          single_file_support = true,
        })
      end,

      -- Next, you can provide a dedicated handler for specific servers.
      -- For example, a handler override for the `rust_analyzer`:
      ["gopls"] = function()
        require("lspconfig")["gopls"].setup({
          -- ok, we're good now
          -- this resolves to /home/adamtajti/go/bin/gopls as we don't have that in the nix environment
          -- cmd = {
          --   "/usr/bin/gopls",
          --   "-remote=auto",
          --   "-remote.listen.timeout=10s",
          --   "serve",
          -- },
          on_attach = on_attach,
          root_dir = require("lspconfig").util.root_pattern(
            "go.work",
            "go.mod",
            ".git"
          ),
          capabilities = capabilities,
          --[[ settings = {
					gopls = {
						allowImplicitNetworkAccess = true,
						experimentalPostfixCompletions = true,
						directoryFilters = {
							"-**/node_modules",
							"-**/vendor",
						},
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						hints = {
							assignVariableTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
				init_options = {
					usePlaceholders = true,
				},
				single_file_support = true,
				flags = {
					allow_incremental_sync = false,
					debounce_text_changes = 500,
				}, ]]
        })
      end,
      -- ["lua_ls"] = function()
      -- 	require("lspconfig")["lua_ls"].setup({
      -- 		settings = {
      -- 			Lua = {
      -- 				format = {
      -- 					enable = false,
      -- 				},
      -- 				runtime = {
      -- 					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      -- 					version = "LuaJIT",
      -- 				},
      -- 				codeLens = {
      -- 					enable = true,
      -- 				},
      -- 				diagnostics = {
      -- 					-- Get the language server to recognize the `vim` global
      -- 					globals = {
      -- 						"vim",
      -- 						"ls",
      -- 						"s",
      -- 						"sn",
      -- 						"t",
      -- 						"i",
      -- 						"f",
      -- 						"c",
      -- 						"d",
      -- 						"r",
      -- 						"events",
      -- 						"ai",
      -- 						"extras",
      -- 						"l",
      -- 						"rep",
      -- 						"p",
      -- 						"m",
      -- 						"n",
      -- 						"dl",
      -- 						"fmt",
      -- 						"fmta",
      -- 						"conds",
      -- 						"postfix",
      -- 						"types",
      -- 						"parse",
      -- 						"ms",
      -- 						"k",
      -- 						"conds",
      -- 						"conds_expand",
      -- 					},
      -- 					disable = { "missing-parameters", "missing-fields", "inject-field" },
      -- 				},
      -- 				workspace = {
      -- 					-- Make the server aware of Neovim runtime files
      -- 					--   (this should include the Lazy.nvim plugins as well)
      -- 					library = vim.api.nvim_get_runtime_file("", true),
      -- 					checkThirdParty = false, -- don't ask for configuration again and again
      -- 				},
      -- 				hint = {
      -- 					enable = true,
      -- 					setType = false,
      -- 					paramType = true,
      -- 					paramName = "Disable",
      -- 					semicolon = "Disable",
      -- 					arrayIndex = "Disable",
      -- 				},
      -- 			},
      -- 		},
      -- 		single_file_support = true,
      -- 		on_attach = on_attach,
      -- 		capabilities = capabilities,
      -- 	})
      -- end,
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
      ["yamlls"] = function()
        require("lspconfig")["yamlls"].setup({
          filetypes = { "yaml", "yaml.docker-compose" },
          settings = {
            -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
            redhat = { telemetry = { enabled = false } },
            yaml = {
              hover = true,
              completion = true,
              validate = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              -- schemas = {
              -- 	-- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              -- 	-- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
              -- 	-- ["/path/from/root/of/project"] = "/.github/workflows/*",
              -- },
            },
          },
          single_file_support = true,
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
      ["jsonls"] = function()
        require("lspconfig")["yamlls"].setup({
          filetypes = { "json", "jsonc" },
          settings = {
            json = {
              schemastore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              validate = { enable = true },
            },
          },
        })
      end,
      ["bashls"] = function()
        -- https://github.com/koalaman/shellcheck/wiki/Ignore
        require("lspconfig")["bashls"].setup({
          filetypes = { "sh" },
          settings = {},
          single_file_support = true,
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
    })
  end,
}