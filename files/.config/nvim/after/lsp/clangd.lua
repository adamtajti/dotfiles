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

return {
  cmd = {
    "clangd",
    "--background-index=true",
    "--background-index-priority=normal",
    "--import-insertions",
    "--enable-config",
    "--all-scopes-completion",
    "--log=verbose",
  },
}
