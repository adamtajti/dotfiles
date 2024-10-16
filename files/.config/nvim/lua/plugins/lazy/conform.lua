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
			c = { "uncrustify" },
			cpp = { "uncrustify" },
			go = { "goimports", "goimports-reviser", "gofmt" },
			yaml = { "yamlfmt" },
			terraform = { "terraform_fmt" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			["*"] = { "trim_whitespace" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 10000,
		},
	},
}
