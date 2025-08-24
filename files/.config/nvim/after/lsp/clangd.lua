if
  vim.bo.filetype ~= "c"
  and vim.bo.filetype ~= "cpp"
  and vim.bo.filetype ~= "objc"
  and vim.bo.filetype ~= "objcpp"
  and vim.bo.filetype ~= "cuda"
  and vim.bo.filetype ~= "proto"
then
  return
end

local util = require("lspconfig.util")

local root_dir = function(fname)
  return util.root_pattern(
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac" -- AutoTools
  )(fname) or vim.fs.dirname(
    vim.fs.find(".git", { path = fname, upward = true })[1]
  )
end

local cwd = vim.fn.getcwd()

return {
  cmd = {
    "clangd",
    "--compile-commands-dir=" .. root_dir(cwd),
    "--background-index=true",
    "--background-index-priority=normal",
    "--enable-config",
    "--all-scopes-completion",
    "--log=verbose",
  },
}
