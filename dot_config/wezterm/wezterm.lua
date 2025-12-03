-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- 强制使用 Wayland 后端
config.enable_wayland = true
-- Wayland 下的窗口装饰（Niri 会管理窗口边框）
config.window_decorations = "NONE" -- 或 "RESIZE" 如果你想要调整大小的边框

-- or, changing the font size and color scheme.
config.font_size = 12
-- config.color_scheme = "AdventureTime"
config.color_scheme = "Tokyo Night"

-- 字体配置
config.font = wezterm.font_with_fallback({
	"JetBrains Mono", -- 主字体
	"Noto Sans Mono CJK SC", -- 中文支持
	"Symbols Nerd Font", -- 图标字体
})

config.window_background_opacity = 0.75
config.text_background_opacity = 1.0

-- 隐藏标签栏（如果只有一个标签）
config.hide_tab_bar_if_only_one_tab = true
-- 标签栏位置
config.tab_bar_at_bottom = false
-- 使用 fancy 标签栏样式
config.use_fancy_tab_bar = false
-- 标签最大宽度
config.tab_max_width = 32

-- 启用 GPU 加速
config.front_end = "WebGpu" -- 现代 GPU 加速后端
-- 最大 FPS
config.max_fps = 120
-- 滚动缓冲区
config.scrollback_lines = 10000

config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.enable_tab_bar = true -- 保留标签栏以管理多个终端会话

-- Finally, return the configuration to wezterm:
return config
