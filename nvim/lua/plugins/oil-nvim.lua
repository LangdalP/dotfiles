return {
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ee", ":Oil<CR>" },
      {
        "<leader>ec",
        function()
          vim.api.nvim_set_current_dir(require("oil").get_current_dir() or error("Could not get cwd from oil"))
        end,
      },
    },
  },
}
