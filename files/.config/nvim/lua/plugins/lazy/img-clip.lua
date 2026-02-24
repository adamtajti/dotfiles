local HOME = os.getenv("HOME")

---@type LazyPluginSpec
return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = function()
        local dropbox_path = HOME .. "/Dropbox"

        local bufname = vim.api.nvim_buf_get_name(0)

        -- If the currently opened buffer is a file in the notebook
        local notebook_path = dropbox_path .. "/Notebook"
        if string.find(bufname, notebook_path, 1, true) then
          return notebook_path .. "/assets"
        end

        -- If the current buffer is in the home folder at all
        if string.find(bufname, HOME, 1, true) then
          local folder_path = vim.fs.dirname(bufname)
          return folder_path .. "/assets"
        end

        return notebook_path .. "/Assets/neovim-img-clip/"
      end,
    },
  },
  keys = {
    {
      "<leader>mp",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from system clipboard",
    },
  },
}
