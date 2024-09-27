-- The Chosen Debug Adapter Protocol (DAP) Client
--
-- DAP-Client ----- Debug Adapter ------- Debugger ------ Debugee
-- (nvim-dap)  |   (per language)  |   (per language)    (your app)
--             |                   |
--             |        Implementation specific communication
--             |        Debug adapter and debugger could be the same process
--             |
--      Communication via the Debug Adapter Protocol
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
	},
	event = "VeryLazy",
	config = function()
		local dap = require("dap")

		-- TODO: Debug Adapter Protocol Adapter for TypeScript (P2)
		-- TODO: Debug Adapter Protocol Adapter for Python (P3)
		-- TODO: Debug Adapter Protocol Adapter for Ruby (P3)

		-- TODO: The delve adapter seems to act up often. I may need to look deeper into this.
		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
		}

		dap.adapters.bashdb = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
			name = "bashdb",
		}

		-- I haven't looked into these yet
		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "./mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
		}

		dap.configurations.javascriptreact = { -- change this to javascript if needed
			{
				type = "chrome",
				request = "attch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
		}

		dap.configurations.typescriptreact = { -- change to typescript if needed
			{
				type = "chrome",
				request = "attach",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
		}

		-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}", -- I'm not sure if this is enough. If the test file is seperate
			},
			-- works with go.mod packages and sub packages
			{
				type = "delve",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}

		dap.configurations.sh = {
			{
				type = "bashdb",
				request = "launch",
				name = "Launch file",
				showDebugOutput = true,
				pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
				pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
				trace = true,
				file = "${file}",
				program = "${file}",
				cwd = "${workspaceFolder}",
				pathCat = "cat",
				pathBash = "/bin/bash",
				pathMkfifo = "mkfifo",
				pathPkill = "pkill",
				args = {},
				env = {},
				terminalKind = "integrated",
			},
		}

		-- Because these can happen right at the start, dap is no longer
		-- lazy compatible
		vim.cmd([[
      augroup dap_vscode_launchjson_load
        autocmd!
        autocmd DirChanged * lua if vim.fn.filereadable('./.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end
      augroup end
    ]])

		vim.api.nvim_create_autocmd({ "DirChanged" }, {
			callback = function()
				if vim.fn.filereadable("./.vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs()
				end
			end,
			pattern = "*",
		})

		-- DirChanged			After the |current-directory| was changed.
		-- The pattern can be:
		-- 	"window"  to trigger on `:lcd`
		-- 	"tabpage" to trigger on `:tcd`
		-- 	"global"  to trigger on `:cd`
		-- 	"auto"    to trigger on 'autochdir'.
		-- Sets these |v:event| keys:
		--     cwd:            current working directory
		--     scope:          "global", "tabpage", "window"
		--     changed_window: v:true if we fired the event
		--                     switching window (or tab)
		-- <afile> is set to the new directory name.
		-- Non-recursive (event cannot trigger itself).

		-- Keymaps
		-- Continue Keymaps
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Dc",
			":lua require'dap'.continue()<CR>",
			{ desc = "Continue Debugger", noremap = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Ds",
			":lua require'dap'.continue()<CR>",
			{ desc = "Start Debugger", noremap = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<F5>",
			":lua require'dap'.continue()<CR>",
			{ desc = "Start Debugger", noremap = true }
		)
		-- Step Over Keymaps
		vim.api.nvim_set_keymap("n", "<leader>Dj", ":lua require'dap'.step_over()<CR>", {
			desc = "Step Over (j: down arrow  step over)",
		})
		vim.api.nvim_set_keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", {
			desc = "Step Over (j: down arrow  step over)",
		})
		-- Step Into Keymaps
		vim.api.nvim_set_keymap("n", "<leader>Dl", ":lua require'dap'.step_into()<CR>", {
			desc = "Step Into (l: right arrow -> step into)",
			noremap = true,
		})
		vim.api.nvim_set_keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", {
			desc = "Step Into (l: right arrow -> step into)",
			noremap = true,
		})
		-- Step Out Keymaps
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Dh",
			":lua require'dap'.step_out()<CR>",
			{ desc = "Step Out (h: left arrow <- step out)", noremap = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<S-F11>",
			":lua require'dap'.step_out()<CR>",
			{ desc = "Step Out", noremap = true }
		)

		vim.api.nvim_set_keymap("n", "<leader>Dk", "", {
			desc = "Peek value in floating win",
			silent = true,
			noremap = true,
			callback = function()
				require("dap.ui.widgets").hover()
			end,
		})

		vim.api.nvim_set_keymap("n", "<leader>DK", "", {
			desc = "Peek value in sidebar win",
			silent = true,
			noremap = true,
			callback = function()
				local widgets = require("dap.ui.widgets")
				local my_sidebar = widgets.sidebar(widgets.scopes)
				my_sidebar.open()
			end,
		})

		vim.api.nvim_set_keymap(
			"n",
			"<leader>DT",
			":lua require('dap-go').debug_test()<CR>",
			{ desc = "Debug Test at Cursor", noremap = true }
		)

		vim.api.nvim_set_keymap("n", "<leader>Db", ":lua require'dap'.toggle_breakpoint()<CR>", {
			desc = "Toggle Breakpoint",
			noremap = true,
		})

		vim.api.nvim_set_keymap(
			"n",
			"<F8>",
			":lua require'dap'.toggle_breakpoint()<CR>",
			{ desc = "Toggle Breakpoint", noremap = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>DB",
			":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
			{ desc = "Toggle Breakpoint with condition", noremap = true }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Dlp",
			":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			{ desc = "Log Point Message", noremap = true }
		)
		vim.api.nvim_set_keymap("n", "<leader>Dr", ":lua require'dap'.repl.open()<CR>", {
			desc = "REPL Open",
			noremap = true,
		})
		vim.api.nvim_set_keymap("n", "<leader>Drl", ":lua require'dap'.repl.run_last()<CR>`", {
			desc = "REPL Run Last",
			noremap = true,
		})

		-- this was set to trace, I imagine that generated a lot of logs
		-- require("dap").set_log_level("debug")
		require("dap").set_log_level("warn")
	end,
}
