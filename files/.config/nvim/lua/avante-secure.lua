local M = {}

M.config = {
  debug = false,
  provider = "ollama",

  behaviour = {
    auto_approve_tool_permissions = { "view", "ls", "glob", "grep" },
    allow_access_to_git_ignored_files = false,
  },

  prompt_logger = { enabled = false },

  providers = {
    ollama = { endpoint = "http://127.0.0.1:11434", model = "gemma4:e4b" },

    -- Personal
    ["claude-personal"] = {
      __inherited_from = "claude",
      model = "claude-opus-4-20250514",
    },
    ["deepseek-personal"] = {
      __inherited_from = "openai",
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-coder",
      api_key = os.getenv("DEEPSEEK_API_KEY"),
    },
    ["gemini-personal"] = {
      __inherited_from = "gemini",
      model = "gemini-2.0-flash",
      api_key = os.getenv("GEMINI_API_KEY"),
    },
    ["openrouter-personal"] = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      model = "anthropic/claude-sonnet-4-5-20250929",
      api_key = os.getenv("OPENROUTER_API_KEY"),
    },
    ["p-opencode"] = { command = "zsh", args = { "-ic", "p-opencode", "acp" } },

    -- Work
    ["claude-work"] = {
      __inherited_from = "claude",
      model = "claude-opus-4-20250514",
    },
    ["deepseek-work"] = {
      __inherited_from = "openai",
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-coder",
      api_key = os.getenv("DEEPSEEK_API_KEY_WORK"),
    },
    ["gemini-work"] = {
      __inherited_from = "gemini",
      model = "gemini-2.0-flash",
      api_key = os.getenv("GEMINI_API_KEY_WORK"),
    },
    ["openrouter-work"] = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      model = "anthropic/claude-sonnet-4-5-20250929",
      api_key = os.getenv("OPENROUTER_API_KEY_WORK"),
    },
    ["t-opencode"] = { command = "zsh", args = { "-ic", "t-opencode", "acp" } },
  },
}

function M.detect_context()
  local cwd = vim.uv.cwd() or ""
  if cwd:find("Projects") then
    return "work"
  end
  return "personal"
end

function M.setup()
  local context = M.detect_context()

  local suffix = context == "work" and "-work" or "-personal"

  local active_providers = {
    ollama = M.config.providers.ollama,
    claude = M.config.providers["claude" .. suffix],
    deepseek = M.config.providers["deepseek" .. suffix],
    gemini = M.config.providers["gemini" .. suffix],
    openrouter = M.config.providers["openrouter" .. suffix],
  }

  local active_acp = context == "work"
      and { ["t-opencode"] = M.config.providers["t-opencode"] }
    or { ["p-opencode"] = M.config.providers["p-opencode"] }

  require("avante").setup({
    provider = "ollama",
    providers = active_providers,
    acp_providers = active_acp,
    behaviour = M.config.behaviour,
    prompt_logger = M.config.prompt_logger,
    debug = M.config.debug,
  })

  vim.g.avante_active_context = context
end

function M.switch_to_personal()
  local suffix = "-personal"
  require("avante.config").override({
    provider = "ollama",
    providers = {
      ollama = M.config.providers.ollama,
      claude = M.config.providers["claude" .. suffix],
      deepseek = M.config.providers["deepseek" .. suffix],
      gemini = M.config.providers["gemini" .. suffix],
      openrouter = M.config.providers["openrouter" .. suffix],
    },
    acp_providers = { ["p-opencode"] = M.config.providers["p-opencode"] },
  })
  vim.g.avante_active_context = "personal"
end

function M.switch_to_work()
  local suffix = "-work"
  require("avante.config").override({
    provider = "ollama",
    providers = {
      ollama = M.config.providers.ollama,
      claude = M.config.providers["claude" .. suffix],
      deepseek = M.config.providers["deepseek" .. suffix],
      gemini = M.config.providers["gemini" .. suffix],
      openrouter = M.config.providers["openrouter" .. suffix],
    },
    acp_providers = { ["t-opencode"] = M.config.providers["t-opencode"] },
  })
  vim.g.avante_active_context = "work"
end

function M.get_context() return vim.g.avante_active_context or "personal" end

return M
