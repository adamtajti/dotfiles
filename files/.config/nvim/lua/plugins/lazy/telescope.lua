local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

-- Telescope was used in place of fzf to provide a fuzzy file searcher for code navigation
-- Now it's used for a couple of git operations as well. To look at recently opened files.
-- To show the currently occupied ports on the system
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "LennyPhoenix/project.nvim",
      branch = "fix-get_clients",
    },
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    "LinArcX/telescope-ports.nvim",
    -- "nvim-telescope/telescope-dap.nvim",
    "benfowler/telescope-luasnip.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "notify",
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  cmd = "Telescope",
  opts = function()
    local delete_buffer_forcefully = function(prompt_bufnr)
      local action_state = require("telescope.actions.state")
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      current_picker:delete_selection(function(selection)
        local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, {
          force = true,
        })
        return ok
      end)
    end

    local actions = require("telescope.actions")

    local tulip_path = os.getenv("TULIP_PATH")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<S-ESC>"] = delete_buffer_forcefully,
            ["<C-CR>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<S-CR>"] = actions.send_to_qflist + actions.open_qflist,
            ["<Leader>R"] = actions.select_all,
            ["<Leader>r"] = actions.toggle_all,
            ["<Leader>d"] = actions.delete_buffer,
            ["<Leader>D"] = delete_buffer_forcefully,
            ["<Leader>h"] = "which_key",
          },
          n = {},
        },
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            width = 0.99,
            height = 0.99,
            mirror = true,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case. the default case_mode is "smart_case"
        },
      },
    })

    local telescope = require("telescope")

    -- fzf-native is a c port of fzf. It only covers the algorithm and implements few functions to
    -- support calculating the score.
    telescope.load_extension("fzf")

    -- An extension for telescope.nvim that allows you to switch between projects.
    telescope.load_extension("projects")

    -- Shows ports that are open on your system and gives you the ability to kill their
    -- process.(linux only)
    telescope.load_extension("ports")

    -- Integration for nvim-dap with telescope.nvim. This plugin is also overriding dap internal ui,
    -- so running any dap command, which makes use of the internal ui, will result in a telescope
    -- prompt.
    -- telescope.load_extension("dap")

    -- Snippets
    telescope.load_extension("luasnip")

    -- Pass arguments to the live grep search
    telescope.load_extension("live_grep_args")
  end,
  keys = {
    {
      "<leader>csf",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
        })
      end,
      desc = "Find Files (CWD)",
      noremap = true,
    },
    -- TODO: Move this to luasnip
    {
      "<C-s>",
      mode = "i",
      function() require("telescope").extensions.luasnip.luasnip({}) end,
      desc = "Find snippet",
      noremap = true,
    },
    -- TODO: Move this to luasnip
    {
      "<leader>Ss",
      function() require("telescope").extensions.luasnip.luasnip({}) end,
      desc = "Search & Pick",
      noremap = true,
    },
    {
      "<Leader>gsf",
      function()
        require("telescope.builtin").git_files({
          hidden = true,
          show_untracked = true,
        })
      end,
      desc = "Files",
      noremap = true,
    },
    {
      "<Leader>gst",
      function()
        local open_pop = assert(io.popen("git rev-parse --show-toplevel", "r"))
        local repo_root = trim(open_pop:read("*all"))
        open_pop:close()

        require("telescope").extensions.live_grep_args.live_grep_args({
          cwd = repo_root,
          hidden = true,
          additional_args = {
            "--hidden",
          },
        })
      end,
      desc = "Text",
      noremap = true,
    },
    {
      "<Leader>cst",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          hidden = true,
          additional_args = {
            "--hidden",
          },
        })
      end,
      desc = "Text",
      noremap = true,
    },
    {
      "<Leader>cso",
      function()
        require("telescope.builtin").oldfiles({
          only_cwd = true,
        })
      end,
      desc = "Previously Opened Files",
      noremap = true,
    },
    {
      "<Leader>gso",
      function()
        local open_pop = assert(io.popen("git rev-parse --show-toplevel", "r"))
        local repo_root = trim(open_pop:read("*all"))
        open_pop:close()

        require("telescope.builtin").oldfiles({
          cwd = repo_root,
          only_cwd = true,
        })
      end,
      desc = "Previously Opened Files",
      noremap = true,
    },
    {
      "<Leader>to",
      function() require("telescope.builtin").oldfiles({}) end,
      desc = "Previously Opened Files",
      noremap = true,
    },
    {
      "<Leader>tr",
      function() require("telescope.builtin").resume() end,
      desc = "Resume Previous Search",
      noremap = true,
    },
    {
      "<Leader>tp",
      function() require("telescope").extensions.projects.projects({}) end,
      desc = "Search Projects",
      noremap = true,
    },
    {
      "<Leader>gc",
      function() require("telescope.builtin").git_commits() end,
      desc = "Commits",
      noremap = true,
    },
    {
      "<Leader>gC",
      function() require("telescope.builtin").git_bcommits() end,
      desc = "Git commits for the current buffer; visual-select lines to track changes in the range",
      noremap = true,
      mode = { "n", "x" },
    },
    {
      "<Leader>gb",
      function() require("telescope.builtin").git_branches() end,
      desc = "Branches",
      noremap = true,
    },
    {
      "<Leader>bl",
      function() require("telescope.builtin").buffers() end,
      desc = "List Buffers",
      noremap = true,
    },
  },
}
