-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.tmpl",
  callback = function()
    local filename = vim.fn.expand("%:t")
    -- 提取 .tmpl 之前的扩展名
    local inner_ext = filename:match("%.([^%.]+)%.tmpl$")

    if inner_ext then
      -- 根据内层扩展名设置 filetype
      vim.bo.filetype = inner_ext
    end
  end,
  desc = "Set filetype for chezmoi templates based on inner extension",
})
