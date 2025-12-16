local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"

config.enable_wayland = true

config.front_end = "WebGpu"

return config
