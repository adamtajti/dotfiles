-- Debug Adapter Protocol (DAP) Client
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
    "suketa/nvim-dap-ruby",
  },
  event = "VeryLazy", -- Improvement: Load only on the keymaps below and the available commands
  config = function()
    local dap = require("dap")

    -----------------------------------------------------------------------------
    -- CUSTOM SETUPS
    -----------------------------------------------------------------------------
    require("dap-ruby").setup()

    -----------------------------------------------------------------------------
    -- ADAPTERS
    -----------------------------------------------------------------------------
    -- TODO: Debug Adapter Protocol Adapter for Ruby (P3)

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

    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data")
          .. "./mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
      },
    }

    dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data")
          .. "/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js",
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
      })
    end

    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(
            port,
            "`connect.port` is required for a python `attach` configuration"
          ),
          host = host,
          options = {
            source_filetype = "python",
          },
        })
      else
        cb({
          type = "executable",
          command = "path/to/virtualenvs/debugpy/bin/python",
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        })
      end
    end

    -- Fresh config, untested
    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        -- Adam: Ok, I guess I'll need some kind of dynamic path / browser here
        args = {
          "/home/adamtajti/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    -----------------------------------------------------------------------------
    -- CONFIGURATIONS
    -----------------------------------------------------------------------------

    dap.configurations.javascriptreact =
      { -- change this to javascript if needed
        {
          name = "chrome",
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

    dap.configurations.typescriptreact = { -- change to typescript if needed
      {
        name = "chrome",
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

    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          else
            return "/usr/bin/python"
          end
        end,
      },
    }

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
    -- https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md
    require("dap").configurations.javascript = {
      {
        type = "pwa-node", -- dap specific
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      require("deus.tulip").dap.configurations.factory.firefox.attach,
    }

    require("dap").configurations.typescript = {
      require("deus.tulip").dap.configurations.factory.firefox.attach,
    }

    -----------------------------------------------------------------------------
    -- VSCode Hacks
    -----------------------------------------------------------------------------
    -- TODO: Look into how this is currently handled. load_launchjs seems to be
    -- deprecated
    --
    -- Keeps throwing errors, commented out the whole ordeal for now
    --
    -- vim.cmd([[
    --   augroup dap_vscode_launchjson_load
    --     autocmd!
    --     autocmd DirChanged * lua if vim.fn.filereadable('./.vscode/launch.json') then require('dap.ext.vscode').load_launchjs() end
    --   augroup end
    -- ]])
    --
    -- vim.api.nvim_create_autocmd({ "DirChanged" }, {
    --   callback = function()
    --     if vim.fn.filereadable("./.vscode/launch.json") then
    --       require("dap.ext.vscode").load_launchjs()
    --     end
    --   end,
    --   pattern = "*",
    -- })

    -----------------------------------------------------------------------------
    -- KEYMAPS
    -----------------------------------------------------------------------------

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
    vim.keymap.set(
      "n",
      "<leader>dN",
      function() require("osv").launch({ port = 8086 }) end,
      { desc = "osv: NVIM Debugee Init", noremap = true }
    )

    -- this was set to trace, I imagine that generated a lot of logs
    -- require("dap").set_log_level("debug")
    dap.set_log_level("warn")
  end,
}
