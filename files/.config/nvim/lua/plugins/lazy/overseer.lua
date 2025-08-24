return {
  "stevearc/overseer.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>Or",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify(
            "No tasks found. Opening the task list",
            vim.log.levels.WARN
          )
          overseer.open()
        else
          overseer.run_action(tasks[1], "restart")
        end
      end,
      desc = "Restart the last task",
      noremap = true,
    },
    {
      "<leader>Owb",
      function()
        local overseer = require("overseer")
        overseer.run_template(
          { tags = { overseer.TAG.BUILD }, prompt = "avoid" },
          function(task)
            if task then
              overseer.run_action(task, "watch")
            end
          end
        )
      end,
      desc = "Watch Build",
      noremap = true,
    },
    {
      "<leader>On",
      function()
        local overseer = require("overseer")
        overseer.new_task()
      end,
      desc = "New task",
      noremap = true,
    },
    {
      "<leader>Ot",
      function()
        local overseer = require("overseer")
        overseer.toggle()
      end,
      desc = "Toggle",
      noremap = true,
    },
  },
}
