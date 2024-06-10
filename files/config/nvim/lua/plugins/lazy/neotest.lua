return {
	"nvim-neotest/neotest",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-go",
		"haydenmeade/neotest-jest",
		"Issafalcon/neotest-dotnet",
		"alfaix/neotest-gtest",
		"rcasia/neotest-bash",
		"nvim-neotest/neotest-python",
	},
	opts = function()
		require("neotest").setup({
			-- https://github.com/nvim-neotest/neotest?tab=readme-ov-file#supported-runners
			adapters = {
				require("neotest-go"),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
					cwd = function(_)
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-dotnet"),
				require("neotest-gtest"),
				require("neotest-bash"),
				require("neotest-python"),
			},
		})
	end,
	keys = {
		{
			"<Leader>tr",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			noremap = true,
			desc = "Run Test Function",
		},
		{
			"<Leader>tR",
			callback = function()
				require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
			end,
			noremap = true,
			desc = "Run Test File",
		},
		{
			"<Leader>td",
			function()
				-- project_nvim will set this automatically
				require("neotest").run.run(vim.fn.getcwd())
			end,
			noremap = true,
			desc = "Run Test Directory",
		},
	},
}
