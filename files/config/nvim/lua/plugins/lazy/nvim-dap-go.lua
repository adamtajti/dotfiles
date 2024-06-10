-- Golang Debug Adapter Protocol (DAP) Adapter
return{
  "leoluz/nvim-dap-go",
  lazy = false,
  opts = function()
    require("dap-go").setup()
  end,
}
