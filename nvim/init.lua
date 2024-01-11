-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("conform").formatters["sql-formatter"] = {
  command = "sql-formatter",
  stdin = true,
}

require("conform").formatters_by_ft = {
  sql = { "sql-formatter" },
}

-- require("pets").setup({
--   -- your options here
-- })
