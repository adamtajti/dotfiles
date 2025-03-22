local function trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

local function genKeymap(shortcut, envNameToPath, path, relative)
  return {
    "<Leader>o" .. shortcut,
    function()
      if relative == true then
        local openPop = assert(io.popen("git rev-parse --show-toplevel", "r"))
        local repoRoot = trim(openPop:read("*all"))
        openPop:close()
        require("oil").open(repoRoot .. "/" .. path)
      else
        require("oil").open(path)
      end
    end,
    desc = "oil://$" .. envNameToPath,
    noremap = true,
  }
end

local function genKeymapsFromEnvNameToPath(shortcut, envNameToPath, relative)
  local path = os.getenv(envNameToPath)
  return genKeymap(shortcut, envNameToPath, path, relative)
end

local function genTulipKeymapsFromEnvNameToPath(shortcut, envNameToPath)
  return genKeymapsFromEnvNameToPath("t" .. shortcut, envNameToPath, true)
end

local function genTulipKeymapsFromPath(shortcut, name, path)
  return genKeymap(shortcut, name, path, true)
end

return {
  "stevearc/oil.nvim",
  -- event = "VeryLazy",
  lazy = false, -- the author doesn't recommend lazy loading oil
  priority = 200,
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      -- columns = {
      -- 	"icon",
      -- 	"mtime",
      -- },
      buf_options = {
        buflisted = true,
        bufhidden = "hide",
      },
      -- Skip the confirmation popup for simple operations
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = {
          "actions.cd",
          opts = {
            silent = true,
          },
        },
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["<Leader>oe"] = "actions.open_external",
        ["<Leader>os"] = {
          desc = "Open file as sudo",
          noremap = true,
          silent = true,
          callback = function()
            local oil = require("oil")
            local dir = oil.get_current_dir()
            local entry = oil.get_cursor_entry()
            if entry == nil then
              vim.notify("invalid entry")
              return
            end

            local path_to_open = dir .. entry.name
            vim.notify("Path to open: " .. path_to_open, vim.log.levels.DEBUG)
            vim.cmd("SudaRead " .. path_to_open)
          end,
        },
        ["<Leader>of"] = "actions.copy_entry_path",
        -- it would be nice to have a command to follow a symlink
      },
    })
  end,
  -- TODO: Transform these into simple shortcut registrations. Lazy autoreload doesn't handle this
  keys = {
    {
      "<Leader>oc",
      function()
        require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
      end,
      desc = "Oil: Enable columns",
      noremap = true,
    },
    {
      "-",
      function() require("oil").open() end,
      desc = "Open File Explorer",
      noremap = true,
    },
    -- notebook
    genKeymapsFromEnvNameToPath("N", "NOTEBOOK_PATH", false),
    -- neovim
    genKeymapsFromEnvNameToPath("nd", "NVIM_DATA_PATH", false),
    genKeymapsFromEnvNameToPath("ns", "NVIM_STATE_PATH", false),
    genKeymapsFromEnvNameToPath("nc", "NVIM_CACHE_PATH", false),
    genKeymapsFromEnvNameToPath("nl", "NVIM_LAZY_PATH", false),
    -- dotfiles
    genKeymapsFromEnvNameToPath("d", "DOTFILES_PATH", false),
    genKeymapsFromEnvNameToPath("dc", "DOTFILES_CONFIG_PATH", false),
    genKeymapsFromEnvNameToPath("dsn", "DOTFILES_SNIPPETS_PATH", false),
    genKeymapsFromEnvNameToPath("s", "DOTFILES_SNIPPETS_PATH", false),
    genKeymapsFromEnvNameToPath("dsh", "DOTFILES_SHELL_PATH", false),
    genKeymapsFromEnvNameToPath("dn", "DOTFILES_CONFIG_NVIM_PATH", false),
    -- qutebrowser
    genKeymapsFromEnvNameToPath("q", "QUTEBROWSER_PATH", false),
    -- tulip
    genTulipKeymapsFromPath(".", "root", "."),
    genTulipKeymapsFromEnvNameToPath("f", "TULIP_FACTORY_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("n", "TULIP_COMMON_NPM_PATH_FROM_ROOT"),
    -- go services
    genTulipKeymapsFromEnvNameToPath("go", "TULIP_GO_SERVICES_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "gap",
      "TULIP_GO_APIGATEWAY_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("gar", "TULIP_GO_ARCHIVER_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gbo", "TULIP_GO_BOTANIST_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gbr", "TULIP_GO_BROKER_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "ge",
      "TULIP_GO_EDGELOGGER_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "ginc",
      "TULIP_GO_INCIDENTTRACKER_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "ginge",
      "TULIP_GO_INGESTER_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "gingr",
      "TULIP_GO_INGRESSADJUSTER_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "gins",
      "TULIP_GO_INSTANCEMETADATA_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("gl", "TULIP_GO_LIMITING_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "gmi",
      "TULIP_GO_MIGRATIONS_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("gmo", "TULIP_GO_MODELS_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "gra",
      "TULIP_GO_RABBITAUTH_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("grt", "TULIP_GO_RTUNNEL_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gse", "TULIP_GO_SESSIONS_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gsm", "TULIP_GO_SMS_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gst", "TULIP_GO_STEM_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "gtra",
      "TULIP_GO_TRANSCODER_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("gtro", "TULIP_GO_TROWEL_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gtu", "TULIP_GO_TULIPWEB_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath("gv", "TULIP_GO_VISION_PATH_FROM_ROOT"),
    -- ts services
    genTulipKeymapsFromEnvNameToPath("ts", "TULIP_TS_SERVICES_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "ta",
      "TULIP_TS_AUTOMATIONSAPI_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "tb",
      "TULIP_TS_BARN_TRAINSTATION_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "tc",
      "TULIP_TS_CONNECTORREPO_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("te", "TULIP_TS_EMAIL_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "tim",
      "TULIP_TS_IMPORT_EXPORT_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "til",
      "TULIP_TS_INTERNALLIBRARY_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "tm",
      "TULIP_TS_MIGRATIONS_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath(
      "two",
      "TULIP_TS_WORKFLOWS_PATH_FROM_ROOT"
    ),
    genTulipKeymapsFromEnvNameToPath("twr", "TULIP_TS_WRITER_PATH_FROM_ROOT"),
    -- connectors
    genTulipKeymapsFromEnvNameToPath("co", "TULIP_CONNECTORS_PATH_FROM_ROOT"),
    genTulipKeymapsFromEnvNameToPath(
      "ch",
      "TULIP_CONNECTOR_HOST_PATH_FROM_ROOT"
    ),
  },
}
