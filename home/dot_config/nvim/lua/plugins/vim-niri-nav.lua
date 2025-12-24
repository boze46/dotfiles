-- 在你的 lazy.nvim 配置中添加：
return {
  "andergrim/vim-niri-nav",
  config = function()
    -- 可选：启用 workspace 支持
    vim.g.vim_niri_nav_workspace = "true"
  end,
  build = function()
    -- 只在插件安装或更新时执行
    local plugin_path = vim.fn.stdpath("data") .. "/lazy/vim-niri-nav/vim-niri-nav"
    local link_target = vim.fn.expand("~/.local/bin/vim-niri-nav")
    vim.fn.system(string.format('ln -sf "%s" "%s"', plugin_path, link_target))
    vim.fn.system(string.format('chmod +x "%s"', link_target))
  end,
}
