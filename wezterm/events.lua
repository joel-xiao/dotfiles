local wezterm = require("wezterm")
local mux = wezterm.mux

-- 启动时最大化窗口
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- 动态调整字体大小，避免底部空隙
local function readjust_font_size(window, pane)
  local window_dims = window:get_dimensions()
  local pane_dims = pane:get_dimensions()

  local config_overrides = {}
  local initial_font_size = 13
  config_overrides.font_size = initial_font_size

  local max_iterations = 5
  local iteration_count = 0
  local tolerance = 3

  local current_diff = window_dims.pixel_height - pane_dims.pixel_height
  local min_diff = math.abs(current_diff)
  local best_font_size = initial_font_size

  while current_diff > tolerance and iteration_count < max_iterations do
    config_overrides.font_size = config_overrides.font_size + 0.5
    window:set_config_overrides(config_overrides)

    window_dims = window:get_dimensions()
    pane_dims = pane:get_dimensions()
    current_diff = window_dims.pixel_height - pane_dims.pixel_height

    local abs_diff = math.abs(current_diff)
    if abs_diff < min_diff then
      min_diff = abs_diff
      best_font_size = config_overrides.font_size
    end

    iteration_count = iteration_count + 1
  end

  if current_diff > tolerance then
    config_overrides.font_size = best_font_size
    window:set_config_overrides(config_overrides)
  end
end

-- 如果想启用，可解除注释
-- wezterm.on("window-resized", readjust_font_size)
