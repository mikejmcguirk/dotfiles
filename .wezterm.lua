local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local font = wezterm.font("Cousine Nerd Font Mono", { weight = "Regular" })
local font_size = 11.0

config.font = font
config.font_size = font_size

config.window_frame = {
    font = font,
    font_size = font_size,
}

config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "AlwaysPrompt"

config.window_padding = {
    left = 1,
    right = 1,
    top = 1,
    bottom = 1,
}

config.window_background_opacity = 0.8

config.inactive_pane_hsb = {
    saturation = 0.4,
    brightness = 0.4,
}

config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.cursor_blink_rate = 650
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.colors = {
    foreground = "#EEEEEC",
    background = "black",
    cursor_border = "#EEEEEC",
    split = "#d598ff",
    ansi = {
        'black',
        '#9C5467',
        '#7C509B',
        '#916D3F',
        '#459B97',
        '#5E8F3F',
        '#9EAD54',
        'silver',
    },
    brights = {
        'grey',
        '#FF98B3',
        '#D598FF',
        '#FFD298',
        '#98FFFB',
        '#C0FF98',
        '#EDFF98',
        '#EEEEEC',
    },
}

return config
