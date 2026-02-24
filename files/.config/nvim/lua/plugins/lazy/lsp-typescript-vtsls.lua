return {
  "yioneko/nvim-vtsls",
  enabled = true,
  lazy = false,
  keys = {
    {
      "<leader>ltu",
      function()
        local vtsls_commands = require("vtsls.commands")
        local remove_unused_imports = vtsls_commands["remove_unused_imports"]
        remove_unused_imports(0, save, save)
      end,
      desc = "Remove unused references",
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.jsx",
      },
      noremap = true,
    },
  },
}
