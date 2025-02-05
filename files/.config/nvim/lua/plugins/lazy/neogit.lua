--- A git interface for Neovim, inspired by Magit.
--- https://github.com/NeogitOrg/neogit
return {
  "NeogitOrg/neogit",
  -- dir = "~/GitHub/neogit.nvim",
  -- dev = true,
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim", -- optional - Diff integration
    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    -- https://github.com/NeogitOrg/neogit?tab=readme-ov-file#configuration
    require("neogit").setup({
      -- Disables changing the buffer highlights based on where the cursor is.
      disable_context_highlighting = true,
      integrations = {
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
        -- The diffview integration enables the diff popup.
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        -- Disabled: During rebase it brings up a 3 way merge UI, which
        --   is quite alien to me. I just want to stage the conflicts that
        --   i already resolved
        diffview = false,
      },
      kind = "vsplit",
      status = {
        recent_commit_count = 30,
      },
      commit_editor = {
        kind = "tab",
        show_staged_diff = true,
        -- Accepted values:
        -- "split" to show the staged diff below the commit editor
        -- "vsplit" to show it to the right
        -- "split_above" Like :top split
        -- "vsplit_left" like :vsplit, but open to the left
        -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
        staged_diff_split_kind = "vsplit",
        spell_check = true,
        commit_select_view = {
          kind = "vsplit",
        },
        log_view = {
          kind = "vsplit",
        },
      },
      rebase_editor = {
        kind = "tab",
      },
    })

    vim.api.nvim_set_hl(0, "NeogitDiffAdd", { bg = "#00875f", fg = "#e4e4e4" })
    vim.api.nvim_set_hl(
      0,
      "NeogitDiffDelete",
      { bg = "#DC143C", fg = "#e4e4e4" }
    )

    -- More styling options if needed:
    -- NeogitHunkHeader
    -- NeogitDiffContext
    -- NeogitDiffHeader
  end,
  cmd = {
    "Neogit",
    "NeogitResetState",
    "NeogitCommit",
    "NeogitLogCurrent",
  },
  keys = {
    {
      "<Leader>G",
      function()
        -- Open neogit in the current buffer
        require("neogit").open({ kind = "replace" })
      end,
      desc = "NeoGit",
      noremap = true,
    },
  },
}
