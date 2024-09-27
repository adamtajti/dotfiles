-- This is an attempt to collect all LSP related functionalities into a single module

local M = {
	"neovim/nvim-lspconfig",
	--lazy = false,
	event = "BufReadPre",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		"hrsh7th/cmp-nvim-lsp",
		"jubnzv/virtual-types.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- "pmizio/typescript-tools.nvim",
		"lazy-deus",
	},
}

M.manually_installed = {
	"tsserver", -- TypeScript
}

-- These are mason-lspconfig specific server names. Many of the none-ls / null-ls servers are not listed here.
-- /home/adamtajti/.local/share/nvim/lazy/mason-lspconfig.nvim/doc/server-mapping.md
M.ensure_installed = {
	"clangd", -- clangd understands your C++ code and adds smart features to your editor: code completion, compile errors, go-to-definition and more.
	"omnisharp", -- OmniSharp language server based on Roslyn workspaces. This version of Omnisharp requires dotnet (.NET 6.0) to be installed.
	"pyright", -- Static type checker for Python.
	"black", -- Black, the uncompromising Python code formatter.
	"solargraph", -- Solargraph is a Ruby gem that provides intellisense features through the language server protocol.
	"rust-analyzer", -- rust-analyzer is an implementation of the Language Server Protocol for the Rust programming language. It provides features like completion and goto definition for many code editors, including VS Code, Emacs and Vim.
	"json-lsp", -- Language Server Protocol implementation for JSON.
	"stylua", -- An opinionated Lua code formatter.
	"prettierd", -- Prettier, as a daemon, for ludicrous formatting speed.
	"jdtls", -- Java language server.
	"yamlfmt", -- yamlfmt is an extensible command line tool or library to format yaml files.
	"luacheck", -- A tool for linting and static analysis of Lua code.
	"eslint_d", -- Makes eslint the fastest linter on the planet.
	"shellcheck", -- ShellCheck, a static analysis tool for shell scripts.
	"shfmt", -- A shell formatter (sh/bash/mksh).
	"fixjson", -- A JSON file fixer/formatter for humans using (relaxed) JSON5.
	"html-lsp", -- Language Server Protocol implementation for HTML.
	"bash-language-server", -- A language server for Bash.
	"typescript-language-server", -- TypeScript & JavaScript Language Server.
	"lua-language-server", -- A language server that offers Lua language support - programmed in Lua.
	"dockerfile-language-server", -- A language server for Dockerfiles powered by Node.js, TypeScript, and VSCode technologies.
	"docker-compose-language-service", -- A language server for Docker Compose.
	"yaml-language-server", -- Language Server for YAML Files.
	"vim-language-server", -- VimScript language server.
	"terraform-ls", -- Terraform Language Server.
	"tflint", -- A Pluggable Terraform Linter.
	"djlint", -- HTML Template Linter and Formatter. Django - Jinja - Nunjucks - Handlebars - GoLang.
	"goimports", -- A golang formatter which formats your code in the same style as gofmt and additionally updates your Go import lines, adding missing ones and removing unreferenced ones.
	"goimports-reviser", -- Tool for Golang to sort goimports by 3-4 groups: std, general, company (optional), and project dependencies. Also, formatting for your code will be prepared (so, you don't need to use gofmt or goimports separately). Use additional option -rm-unused to remove unused imports and -set-alias to rewrite import aliases for versioned packages.
	"golines", -- A golang formatter that fixes long lines.
	"gomodifytags", -- Go tool to modify/update field tags in structs.
	"golangci-lint", -- golangci-lint is a fast Go linters runner. It runs linters in parallel, uses caching, supports yaml config, has integrations with all major IDE and has dozens of linters included.
	"delve", -- Delve is a debugger for the Go programming language.
	"prettierd", -- Prettier, as a daemon, for ludicrous formatting speed.
	"rubocop", -- The Ruby Linter/Formatter that Serves and Protects.
}

function M.on_attach(client, bufnr)
	--print("client: ", vim.inspect(client), "bufnr: ", vim.inspect(bufnr))
	if client == nil or bufnr == nil then
		--print("WARN: on_attach called with nil client or bufnr")
		return
	end

	--print(vim.inspect(client.server_capabilities))
	-- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Navigational
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "", {
		desc = "Go to Declaration",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.declaration()
		end,
	})

	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "", {
		desc = "Go to Definition",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.definition()
		end,
	})

	vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "", {
		desc = "Go to Type Definition",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.type_definition()
		end,
	})

	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "", {
		desc = "Go to Implementation",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.implementation()
		end,
	})

	-- Informational

	-- It would be nice if this would work with mouse as well.
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", {
		desc = "Display Hover Information (documentation)",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.hover()
		end,
	})

	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "", {
		desc = "Display Signature Help",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.signature_help()
		end,
	})

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>tl",
		[[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
		{ desc = "Search in LSP Document Symbols", noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "", {
		desc = "Lists all References",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.references()
		end,
	})

	-- Reformat
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lrr", "", {
		desc = "Rename symbol",
		noremap = true,
		silent = true,
		callback = function()
			vim.lsp.buf.rename()
		end,
	})

	--[[ if client.server_capabilities.documentFormattingProvider then
	end ]]
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<Leader>f",
		"<cmd>lua vim.lsp.buf.format { async = true, timeout_ms = 5000 }<CR>",
		{ noremap = true, silent = true, desc = "LSP: Format Current Document" }
	)

	-- Do automatic file formatting, reformat over here
	-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	-- 	buffer = bufnr,
	-- 	callback = function()
	-- 		if client.name == "typescript-tools" then
	-- 			local ts_tools_api = require("typescript-tools.api")
	-- 			-- add missing imports in sync
	-- 			-- COMMENTED-OUT: This seems to fail on the latest master with:
	-- 			-- lua/typescript-tools/api.lua:35: attempt to index local 'res' (a nil value)
	-- 			-- ts_tools_api.add_missing_imports(true)
	--
	-- 			-- sorts and removes unused imports
	-- 			-- COMMENTED-OUT: This seems to fail on the latest master with:
	-- 			-- lua/typescript-tools/api.lua:35: attempt to index local 'res' (a nil value)
	-- 			-- ts_tools_api.organize_imports(true)
	-- 		end
	--
	-- 		-- I had troubles with autoformatters on wild project
	-- 		-- vim.lsp.buf.format({ async = false, timeout_ms = 5000 })
	-- 	end,
	-- })

	--print(vim.inspect(client.server_capabilities))

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"v",
		"<Leader>lf",
		"<cmd>lua vim.lsp.buf.format { async = true, timeout_ms = 5000 }<CR>",
		{ noremap = true, silent = true, desc = "LSP: Format the selected range" }
	)
	--[[ if client.server_capabilities.documentRangeFormattingProvider then
	end ]]

	-- if client.name == "typescript-tools" then
	-- 	local ts_tools_api = require("typescript-tools.api")
	-- 	--- Organize imports for TypeScript files. Unfortunate to have to do two
	-- 	--- separate actions, but unfortunately it's the way the language server is
	-- 	--- setup.
	--
	-- 	vim.keymap.set("n", "<Leader>lta", "", {
	-- 		desc = "LSP: TSTools: Add Missing Imports",
	-- 		noremap = true,
	-- 		silent = true,
	-- 		callback = function()
	-- 			ts_tools_api.add_missing_imports(true)
	-- 		end,
	-- 	})
	--
	-- 	vim.keymap.set("n", "<Leader>lto", "", {
	-- 		desc = "LSP: TSTools: Organize Imports (sort and remove unused)",
	-- 		noremap = true,
	-- 		silent = true,
	-- 		callback = function()
	-- 			ts_tools_api.organize_imports(true)
	-- 		end,
	-- 	})
	--
	-- 	vim.keymap.set("n", "<leader>lrf", "", {
	-- 		desc = "LSP: TSTools: Rename File",
	-- 		noremap = true,
	-- 		silent = true,
	-- 		callback = function()
	-- 			ts_tools_api.rename_file(true)
	-- 		end,
	-- 	})
	--
	-- 	vim.keymap.set("n", "<leader>lrf", "", {
	-- 		desc = "LSP: TSTools: File References",
	-- 		noremap = true,
	-- 		silent = true,
	-- 		callback = function()
	-- 			ts_tools_api.file_references(true)
	-- 		end,
	-- 	})
	-- end

	-- Turning on native inlay hints automatically for every LSP on_attach (disabled, doesn't work with typescript for example)
	-- vim.lsp.inlay_hint.enable()
end

function M.config()
	require("mason").setup({
		log_level = vim.log.levels.DEBUG, -- [..., TRACE]
		registries = {
			"github:mason-org/mason-registry",
		},
	})

	require("mason-lspconfig").setup({
		-- ensure_installed = M.ensure_installed,
		-- automatic_installation = true,
	})

	require("mason-tool-installer").setup({
		ensure_installed = M.ensure_installed,
		auto_update = true,
		run_on_start = true,
		start_delay = 3000,
	})

	-- Install tools, which may be used by none-ls (TODO: Migrate these parts over there)
	-- Commented out: I think I'll manage the Mason installations manually. It takes up quite
	-- a bit of time to roll through this on startup.
	-- M.installMissingTools()

	-- Turns this on for Debug messages
	-- vim.lsp.set_log_level("debug")
	--vim.lsp.set_log_level("trace")

	-- require("typescript-tools").setup({
	-- 	on_attach = M.on_attach,
	-- 	settings = {
	-- 		-- spawn additional tsserver instance to calculate diagnostics on it
	-- 		separate_diagnostic_server = true,
	-- 		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
	-- 		publish_diagnostic_on = "insert_leave",
	-- 		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
	-- 		-- "remove_unused_imports"|"organize_imports") -- or string "all"
	-- 		-- to include all supported code actions
	-- 		-- specify commands exposed as code_actions
	-- 		expose_as_code_action = "all",
	-- 		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
	-- 		-- not exists then standard path resolution strategy is applied
	-- 		tsserver_path = nil,
	-- 		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
	-- 		-- (see 💅 `styled-components` support section)
	-- 		--
	-- 		-- MANUAL-INSTALLATION-STEP: `npm i -g @styled/typescript-styled-plugin typescript-styled-plugin`
	-- 		-- MANUAL-INSTALLATION-STEP: `npm i -g @styled/typescript-styled-plugin typescript-styled-plugin`
	-- 		-- Right now this step is not executed the plugin automatically, I assume it's because it "requires"
	-- 		-- a global installation and that requires root privileges.
	-- 		tsserver_plugins = {
	-- 			-- for TypeScript v4.9+
	-- 			"@styled/typescript-styled-plugin",
	-- 			-- or for older TypeScript versions
	-- 			-- "typescript-styled-plugin",
	--
	-- 			"@monodon/typescript-nx-imports-plugin",
	-- 		},
	-- 		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
	-- 		-- memory limit in megabytes or "auto"(basically no limit)
	-- 		tsserver_max_memory = "auto",
	-- 		-- described below
	-- 		tsserver_format_options = {},
	-- 		tsserver_file_preferences = {
	-- 			-- Inlay Hints
	-- 			includeInlayParameterNameHints = "all",
	-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
	-- 			includeInlayFunctionParameterTypeHints = true,
	-- 			includeInlayVariableTypeHints = true,
	-- 			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
	-- 			includeInlayPropertyDeclarationTypeHints = true,
	-- 			includeInlayFunctionLikeReturnTypeHints = true,
	-- 			includeInlayEnumMemberValueHints = true,
	-- 		},
	-- 		-- locale of all tsserver messages, supported locales you can find here:
	-- 		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
	-- 		tsserver_locale = "en",
	-- 		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
	-- 		complete_function_calls = true,
	-- 		include_completions_with_insert_text = true,
	-- 		-- CodeLens
	-- 		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
	-- 		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
	-- 		code_lens = "off",
	-- 		-- by default code lenses are displayed on all referencable values and for some of you it can
	-- 		-- be too much this option reduce count of them by removing member references from lenses
	-- 		disable_member_code_lens = true,
	-- 		-- JSXCloseTag
	-- 		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
	-- 		-- that maybe have a conflict if enable this feature. )
	-- 		jsx_close_tag = {
	-- 			enable = true,
	-- 			filetypes = { "javascriptreact", "typescriptreact" },
	-- 		},
	-- 	},
	-- })

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- ClientDiagnosticsTagOptions.capabilities.textDocument.publishDiagnostics.tagSupport.valueSet
	--[[ capabilities.textDocument.publishDiagnostics = {
		tagSupport = { valueSet = { 1 } },
	} ]]

	--ClientSymbolKindOptions.capabilities.textDocument.documentSymbol.symbolKind.valueSet
	--[[ 	capabilities.textDocument.documentSymbol.symbolKind.valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } ]]

	-- Customization of the Completions. Disapled for now, lets check on the default one again.
	-- Reenabling this in hope of getting something working for gopls
	--[[ capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext" },
		snippetSupport = true,
		preselectSupport = false,
		insertReplaceSupport = true,
		labelDetailsSupport = true,
		deprecatedSupport = true,
		commitCharactersSupport = true,
		tagSupport = { valueSet = { 1 } },
		contextSupport = true,
		resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits", -- this was commented out
				"documentHighlight",
				"commitCharacters",
			},
		},
	} ]]

	-- I'll revisit inlay hints later...
	--[[ capabilities.textDocument.inlayHint = {
		dynamicRegistration = true,
		resolveSupport = {
			properties = {},
		},
	} ]]

	require("mason-lspconfig").setup_handlers({
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have
		-- a dedicated handler.
		function(server_name) -- default handler (optional)
			--print("mason-lspconfig: default handler called for " .. server_name)

			-- dont setup the language server if it is already setup
			if vim.tbl_contains(M.manually_installed, server_name) then
				--print("mason-lspconfig skip setup for " .. server_name)
				return
			end

			require("lspconfig")[server_name].setup({
				on_attach = M.on_attach,
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
				cmd = { "/usr/bin/gopls", "-remote=auto", "-remote.listen.timeout=10s", "serve" },
				on_attach = M.on_attach,
				root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
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
		["lua_ls"] = function()
			require("lspconfig")["lua_ls"].setup({
				settings = {
					Lua = {
						format = {
							enable = false,
						},
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						codeLens = {
							enable = true,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"ls",
								"s",
								"sn",
								"t",
								"i",
								"f",
								"c",
								"d",
								"r",
								"events",
								"ai",
								"extras",
								"l",
								"rep",
								"p",
								"m",
								"n",
								"dl",
								"fmt",
								"fmta",
								"conds",
								"postfix",
								"types",
								"parse",
								"ms",
								"k",
								"conds",
								"conds_expand",
							},
							disable = { "missing-parameters", "missing-fields", "inject-field" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							--   (this should include the Lazy.nvim plugins as well)
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false, -- don't ask for configuration again and again
						},
						hint = {
							enable = true,
							setType = false,
							paramType = true,
							paramName = "Disable",
							semicolon = "Disable",
							arrayIndex = "Disable",
						},
					},
				},
				single_file_support = true,
				on_attach = M.on_attach,
				capabilities = capabilities,
			})
		end,
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
				on_attach = M.on_attach,
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
				on_attach = M.on_attach,
				capabilities = capabilities,
			})
		end,
		["clangd"] = function()
			require("lspconfig")["clangd"].setup({
				single_file_support = true,
				on_attach = M.on_attach,
				capabilities = capabilities,
			})
		end,
		["vimls"] = function()
			require("lspconfig")["vimls"].setup({
				init_options = { isNeovim = true },
			})
		end,
		["solargraph"] = function()
			require("lspconfig")["solargraph"].setup({
				on_attach = M.on_attach,
			})
		end,
	})

	-- Setup Keybinds
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap(
		"n",
		"<leader>df",
		"<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 200 })<CR>",
		{ desc = "Show Diagnostic Message Afloat", noremap = true, silent = true }
	)

	vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

	vim.api.nvim_set_keymap(
		"n",
		"<C-.>",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		{ desc = "Code Actions", noremap = true }
	)
end

return M
