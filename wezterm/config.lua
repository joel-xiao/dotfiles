local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- 判断平台
local is_windows = wezterm.target_triple:find("windows")
local leader = is_windows and "CTRL" or "CMD"

-- 默认终端
config.default_prog = wezterm.target_triple:find('windows')
  and { 'pwsh.exe' }
  or { '/bin/zsh' }

-- 默认打开路径
config.default_cwd = is_windows and "H:/xiao" or "~/Documents/xiao/SZLY/Project"

-- 窗口和光标设置
config.native_macos_fullscreen_mode = false
config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.font_size = 13.5
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
config.enable_tab_bar = false
config.window_padding = { left = 3, right = 3, top = 0, bottom = 0 }

-- 背景图片
local bg_path = is_windows and "C:/Users/xiao/.config/wezterm/dark-desert.jpg"
                                or "/Users/" .. os.getenv("USER") .. "/.config/wezterm/dark-desert.jpg"
config.background = {
  { source = { File = bg_path }, hsb = { hue = 1.0, saturation = 1.02, brightness = 0.25 } },
  { source = { Color = "#000" }, width = "100%", height = "100%", opacity = 0.55 },
}

-- 超链接规则
config.hyperlink_rules = {
  { regex = "\\((\\w+://\\S+)\\)", format = "$1", highlight = 1 },
  { regex = "\\[(\\w+://\\S+)\\]", format = "$1", highlight = 1 },
  { regex = "\\{(\\w+://\\S+)\\}", format = "$1", highlight = 1 },
  { regex = "<(\\w+://\\S+)>", format = "$1", highlight = 1 },
  { regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)", format = "$1", highlight = 1 },
  { regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b", format = "mailto:$0" },
}

-- 快捷键
config.keys = {
  -- 标签页
  { key = 't', mods = leader, action = act.SpawnTab "CurrentPaneDomain" },
  { key = '1', mods = leader, action = act.ActivateTab(0) },
  { key = '2', mods = leader, action = act.ActivateTab(1) },
  { key = '3', mods = leader, action = act.ActivateTab(2) },
  { key = '4', mods = leader, action = act.ActivateTab(3) },
  { key = '5', mods = leader, action = act.ActivateTab(4) },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },

  -- 窗口管理
  { key = 'm', mods = leader, action = act.Hide },
  { key = 'w', mods = leader, action = act.CloseCurrentTab{ confirm = false } },

  -- 复制粘贴
  { key = 'c', mods = leader, action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = leader, action = act.PasteFrom 'Clipboard' },

  -- 字体缩放
  { key = '=', mods = leader, action = act.IncreaseFontSize },
  { key = '-', mods = leader, action = act.DecreaseFontSize },
  { key = '0', mods = leader, action = act.ResetFontSize },

  -- 分屏操作
  { key = 'd', mods = leader.."|SHIFT", action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = leader, action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },

  -- Pane 切换
  { key = 'h', mods = leader.."|ALT", action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = leader.."|ALT", action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = leader.."|ALT", action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = leader.."|ALT", action = act.ActivatePaneDirection 'Right' },

  -- Pane 调整大小（跨平台修复）
  { key = 'LeftArrow', mods = leader.."|SHIFT", action = act.AdjustPaneSize{ 'Left', 5 } },
  { key = 'RightArrow', mods = leader.."|SHIFT", action = act.AdjustPaneSize{ 'Right', 5 } },
  { key = 'UpArrow', mods = leader.."|SHIFT", action = act.AdjustPaneSize{ 'Up', 5 } },
  { key = 'DownArrow', mods = leader.."|SHIFT", action = act.AdjustPaneSize{ 'Down', 5 } },

  -- 搜索
  { key = 'f', mods = leader, action = act.Search{ CaseSensitiveString = '' } },

  -- 滚动历史
  { key = 'UpArrow', mods = 'OPT', action = act.ScrollByPage(-0.5) },
  { key = 'DownArrow', mods = 'OPT', action = act.ScrollByPage(0.5) },
  { key = 'PageUp', mods = leader, action = act.ScrollByPage(-1) },
  { key = 'PageDown', mods = leader, action = act.ScrollByPage(1) },

  -- 会话管理 & 配置重载
  { key = 's', mods = leader.."|SHIFT", action = act.ShowLauncherArgs{ flags = 'FUZZY|WORKSPACES' } },
  { key = 'r', mods = leader.."|SHIFT", action = act.ReloadConfiguration },
}

-- 鼠标绑定
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = 'Left' } }, mods = leader, action = act.OpenLinkAtMouseCursor },
  { event = { Up = { streak = 1, button = 'Right' } }, mods = 'NONE', action = act.PasteFrom 'Clipboard' },
}

return config
