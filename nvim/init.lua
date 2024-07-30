-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("conform").formatters["sql-formatter"] = {
  command = "sql-formatter",
  stdin = true,
}

require("conform").formatters_by_ft = {
  sql = { "sql-formatter" },
  json = { "jq", ". -c" },
}

require("scrollbar").setup()

-- Let treesitter handle folding
local vim = vim
local opt = vim.opt
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- TODO: Test that this works. Does telescope currently use rg?
require("telescope").setup({
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
    },
    grep_string = {
      additional_args = { "--hidden" },
    },
    live_grep = {
      additional_args = { "--hidden" },
    },
  },
})

-- Custom command for live grep in current directory
vim.api.nvim_create_user_command(
  "PLiveGrepHere",
  ":lua require('telescope.builtin').live_grep({search_dirs={require('oil').get_current_dir()}})",
  {}
)

-- Allow clipboard copy paste in neovim - needed when using neovide
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>bc",
  ":BufferLineCloseOthers<CR>",
  { noremap = true, silent = true, desc = "Close other buffers" }
)

-- require("pets").setup({
--   -- your options here
-- })
--
