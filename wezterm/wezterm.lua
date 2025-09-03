local wezterm = require("wezterm")

-- 加载基础配置
local config = dofile(wezterm.config_dir .. "/config.lua")

-- 加载事件
dofile(wezterm.config_dir .. "/events.lua")

-- 加载主题映射
local themes = dofile(wezterm.config_dir .. "/themes.lua")

-- 根据环境变量切换配色
local selected_theme = os.getenv("WEZTERM_THEME")
if selected_theme and themes[selected_theme] then
  config.color_scheme = themes[selected_theme]
end

return config
