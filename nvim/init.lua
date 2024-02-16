-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("conform").formatters["sql-formatter"] = {
  command = "sql-formatter",
  stdin = true,
}

require("conform").formatters_by_ft = {
  sql = { "sql-formatter" },
}

require("scrollbar").setup()


-- Allow clipboard copy paste in neovim - needed when using neovide
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>bc', ':BufferLineCloseOthers<CR>',
  { noremap = true, silent = true, desc = "Close other buffers" })

-- require("pets").setup({
--   -- your options here
-- })
--
