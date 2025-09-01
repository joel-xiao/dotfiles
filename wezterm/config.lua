local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  default_cwd = "~/Documents/xiao/SZLY/Project",
  native_macos_fullscreen_mode = false,
  default_cursor_style = "SteadyBar",
  automatically_reload_config = true,
  window_close_confirmation = "NeverPrompt",
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "RESIZE",
  check_for_updates = false,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  -- 输入延迟（解决某些终端应用卡顿）
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
  font_size = 13.5,
  -- 字体
  -- font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
  font = wezterm.font("JetBrainsMonoNL Nerd Font Propo", { weight = "Bold" }),
  enable_tab_bar = false,
  window_padding = {
    left = 3,
    right = 3,
    top = 0,
    bottom = 0,
  },
  background = {
    {
      source = {
        File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/dark-desert.jpg",
      },
      hsb = {
        hue = 1.0,
        saturation = 1.02,
        brightness = 0.25,
      },
      -- attachment = { Parallax = 0.3 },
      -- width = "100%",
      -- height = "100%",
    },
    {
      source = {
        Color = "#000",
      },
      width = "100%",
      height = "100%",
      opacity = 0.55,
    },
  },
  -- from: https://akos.ma/blog/adopting-wezterm/
  hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      -- Before
      --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
      --format = '$0',
      -- After
      regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
      format = "$1",
      highlight = 1,
    },
    -- implicit mailto link
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
  },

  keys = {
    -- 标签页管理
    { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = '1', mods = 'CMD', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'CMD', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'CMD', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'CMD', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'CMD', action = wezterm.action.ActivateTab(4) },
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
    -- 窗口管理
    { key = 'm', mods = 'CMD', action = wezterm.action.Hide },
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentTab{ confirm = false } },
    -- 复制粘贴（与系统一致）
    { key = 'c', mods = 'CMD', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CMD', action = wezterm.action.PasteFrom 'Clipboard' },
    -- 字体缩放
    { key = '=', mods = 'CMD', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'CMD', action = wezterm.action.DecreaseFontSize },
    { key = '0', mods = 'CMD', action = wezterm.action.ResetFontSize },
    -- 分屏操作
    { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CMD', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'CMD|ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'CMD|ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'CMD|ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'CMD|ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'LeftArrow', mods = 'CMD|ALT', action = wezterm.action.AdjustPaneSize{ 'Left', 5 } },
    { key = 'DownArrow', mods = 'CMD|ALT', action = wezterm.action.AdjustPaneSize{ 'Down', 5 } },
    { key = 'UpArrow', mods = 'CMD|ALT', action = wezterm.action.AdjustPaneSize{ 'Up', 5 } },
    { key = 'RightArrow', mods = 'CMD|ALT', action = wezterm.action.AdjustPaneSize{ 'Right', 5 } },
    -- 搜索
    { key = 'f', mods = 'CMD', action = wezterm.action.Search{ CaseSensitiveString = '' } },
    -- 滚动历史
    { key = 'UpArrow', mods = 'OPT', action = wezterm.action.ScrollByPage(-0.5) },
    { key = 'DownArrow', mods = 'OPT', action = wezterm.action.ScrollByPage(0.5) },
    { key = 'PageUp', mods = 'CMD', action = wezterm.action.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CMD', action = wezterm.action.ScrollByPage(1) },
    -- 会话管理
    { key = 's', mods = 'CMD|SHIFT', action = wezterm.action.ShowLauncherArgs{ flags = 'FUZZY|WORKSPACES' } },
    -- 快速重启配置
    { key = 'r', mods = 'CMD|SHIFT', action = wezterm.action.ReloadConfiguration },
  },

  mouse_bindings = {
    -- 按住 CMD 点击链接/文件路径
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CMD',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- 复制粘贴增强
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom 'Clipboard',
    },
  }
}
return config
