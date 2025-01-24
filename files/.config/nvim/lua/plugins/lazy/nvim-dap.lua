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
    -- one-small-step-for-vimkind a.k.a. osv is an adapter for the Neovim lua language
    "jbyuki/one-small-step-for-vimkind",
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
      command = vim.fn.stdpath("data")
        .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
      name = "bashdb",
    }

    -- I haven't looked into these yet
    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data")
          .. "./mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
      },
    }

    dap.configurations.javascriptreact =
      { -- change this to javascript if needed
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
        pathBashdb = vim.fn.stdpath("data")
          .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
        pathBashdbLib = vim.fn.stdpath("data")
          .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
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
    vim.keymap.set(
      "n",
      "<leader>dc",
      function() require("dap").continue() end,
      { desc = "Continue Debugger", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<leader>ds",
      function() require("dap").continue() end,
      { desc = "Start Debugger", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<F5>",
      function() require("dap").continue() end,
      { desc = "Start Debugger", noremap = true }
    )
    -- Step Over Keymaps
    vim.keymap.set(
      "n",
      "<leader>dj",
      function() require("dap").step_over() end,
      {
        desc = "Step Over (j: down arrow  step over)",
      }
    )
    vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, {
      desc = "Step Over (j: down arrow  step over)",
    })
    -- Step Into Keymaps
    vim.keymap.set(
      "n",
      "<leader>dl",
      function() require("dap").step_into() end,
      {
        desc = "Step Into (l: right arrow -> step into)",
        noremap = true,
      }
    )
    vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, {
      desc = "Step Into (l: right arrow -> step into)",
      noremap = true,
    })
    -- Step Out Keymaps
    vim.keymap.set(
      "n",
      "<leader>dh",
      function() require("dap").step_out() end,
      { desc = "Step Out (h: left arrow <- step out)", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<S-F11>",
      function() require("dap").step_out() end,
      { desc = "Step Out", noremap = true }
    )

    vim.keymap.set("n", "<leader>dk", "", {
      desc = "Peek value in floating win",
      silent = true,
      noremap = true,
      callback = function() require("dap.ui.widgets").hover() end,
    })

    vim.keymap.set("n", "<leader>dK", "", {
      desc = "Peek value in sidebar win",
      silent = true,
      noremap = true,
      callback = function()
        local widgets = require("dap.ui.widgets")
        local my_sidebar = widgets.sidebar(widgets.scopes)
        my_sidebar.open()
      end,
    })

    vim.keymap.set(
      "n",
      "<leader>dT",
      function() require("dap-go").debug_test() end,
      { desc = "Debug Test at Cursor", noremap = true }
    )

    vim.keymap.set(
      "n",
      "<leader>db",
      function() require("dap").toggle_breakpoint() end,
      {
        desc = "Toggle Breakpoint",
        noremap = true,
      }
    )

    vim.keymap.set(
      "n",
      "<F8>",
      function() require("dap").toggle_breakpoint() end,
      { desc = "Toggle Breakpoint", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      { desc = "Toggle Breakpoint with condition", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<leader>dlp",
      function()
        require("dap").set_breakpoint(
          nil,
          nil,
          vim.fn.input("Log point message: ")
        )
      end,
      { desc = "Log Point Message", noremap = true }
    )
    vim.keymap.set(
      "n",
      "<leader>dr",
      function() require("dap").repl.open() end,
      {
        desc = "REPL Open",
        noremap = true,
      }
    )
    vim.keymap.set(
      "n",
      "<leader>drl",
      function() require("dap").repl.run_last() end,
      {
        desc = "REPL Run Last",
        noremap = true,
      }
    )

    -- this was set to trace, I imagine that generated a lot of logs
    -- require("dap").set_log_level("debug")
    require("dap").set_log_level("warn")
  end,
}
