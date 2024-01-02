-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local wk = require("which-key")

wk.register({
  p = {
    name = "peder",
  },
}, {
  prefix = "<leader>",
})

map("n", "<leader>pl", ":set invrelativenumber<CR>")
map("n", "<leader>pw", ":set wrap! linebreak!<CR>")

map("n", "<leader>pn", ':Telescope live_grep search_dirs={"~/Notes"}<CR>')

map("n", "<leader>pr", ":Telescope resume<CR>")

map("n", "<c-p>", "<Plug>(YankyCycleForward)")
map("n", "<c-n>", "<Plug>(YankyCycleBackward)")

map("n", "<leader>ch", ":lua vim.lsp.buf.hover()<CR>")
