local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.default_cwd = "H:/xiao"
config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.font_size = 13.5
config.font = wezterm.font("JetBrainsMonoNL Nerd Font Propo", { weight = "Bold" })
config.enable_tab_bar = false
config.window_padding = { left = 3, right = 3, top = 0, bottom = 0 }

-- 背景（改成你自己的 Windows 路径，或者先注释掉）
config.background = {
  {
    source = { File = "C:/Users/xiao/.config/wezterm/dark-desert.jpg" },
    hsb = { hue = 1.0, saturation = 1.02, brightness = 0.25 },
  },
  {
    source = { Color = "#000" },
    width = "100%",
    height = "100%",
    opacity = 0.55,
  },
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
  { key = "t", mods = "CMD", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
  { key = "m", mods = "CMD", action = wezterm.action.Hide },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = "c", mods = "CMD", action = wezterm.action.CopyTo "Clipboard" },
  { key = "v", mods = "CMD", action = wezterm.action.PasteFrom "Clipboard" },
  { key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  { key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "d", mods = "CMD", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "j", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection "Down" },
  { key = "k", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "l", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection "Right" },
  { key = "LeftArrow", mods = "CMD|ALT", action = wezterm.action.AdjustPaneSize { "Left", 5 } },
  { key = "DownArrow", mods = "CMD|ALT", action = wezterm.action.AdjustPaneSize { "Down", 5 } },
  { key = "UpArrow", mods = "CMD|ALT", action = wezterm.action.AdjustPaneSize { "Up", 5 } },
  { key = "RightArrow", mods = "CMD|ALT", action = wezterm.action.AdjustPaneSize { "Right", 5 } },
  { key = "f", mods = "CMD", action = wezterm.action.Search { CaseSensitiveString = "" } },
  { key = "UpArrow", mods = "OPT", action = wezterm.action.ScrollByPage(-0.5) },
  { key = "DownArrow", mods = "OPT", action = wezterm.action.ScrollByPage(0.5) },
  { key = "PageUp", mods = "CMD", action = wezterm.action.ScrollByPage(-1) },
  { key = "PageDown", mods = "CMD", action = wezterm.action.ScrollByPage(1) },
  { key = "s", mods = "CMD|SHIFT", action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
  { key = "r", mods = "CMD|SHIFT", action = wezterm.action.ReloadConfiguration },
}

-- 鼠标绑定
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Up = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action.PasteFrom "Clipboard",
  },
}

return config
