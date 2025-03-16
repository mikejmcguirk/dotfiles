local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

local font = wezterm.font("Cousine Nerd Font Mono", { weight = "Regular" })
local font_size = 11.0
config.font = font
config.font_size = font_size

config.max_fps = 60 -- My monitors are old

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true

config.window_padding = {
    left = 1,
    right = 1,
    top = 0,
    bottom = 0,
}

config.window_background_opacity = 0.86
config.inactive_pane_hsb = {
    saturation = 0.25,
    brightness = 0.275,
}

config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.cursor_blink_rate = 650
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

local function is_vim(pane)
    local process_info = pane:get_foreground_process_info()
    if process_info then
        return process_info.name
            and (
                    string.find(string.lower(process_info.name), "nvim")
                    or string.find(string.lower(process_info.name), "vim")
                )
                ~= nil
    end

    return false
end

local function conditional_pane_navigation(key, direction)
    return wezterm.action_callback(function(window, pane)
        if is_vim(pane) then
            window:perform_action(wezterm.action.SendKey({ key = key, mods = "CTRL" }), pane)
        else
            window:perform_action(wezterm.action.ActivatePaneDirection(direction), pane)
        end
    end)
end

config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
-- TODO: Create an equivalent of <C-w>= in Nvim for panes
-- TODO: Should also have an equivalent of the <C-w>o command in Nvim
config.keys = {
    -- Pane Management
    {
        key = [[\]],
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "-",
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    { key = "h", mods = "CTRL", action = conditional_pane_navigation("h", "Left") },
    { key = "j", mods = "CTRL", action = conditional_pane_navigation("j", "Down") },
    { key = "k", mods = "CTRL", action = conditional_pane_navigation("k", "Up") },
    { key = "l", mods = "CTRL", action = conditional_pane_navigation("l", "Right") },
    { key = "o", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
    {
        key = "x",
        mods = "LEADER",
        action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
        key = "LeftArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Left", 2 }),
    },
    {
        key = "RightArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Right", 2 }),
    },
    {
        key = "UpArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Up", 2 }),
    },
    {
        key = "DownArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Down", 2 }),
    },
    -- Tab Management
    { key = "t", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "z", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    { key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
    { key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(9) },
    { key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
    { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
    -- Other
    { key = "c", mods = "LEADER|CTRL", action = wezterm.action.Nop }, -- Cancel leader mode
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
    -- I have not figured out a way on Windows to make hjkl navigation work seamlessly with Neovim
    -- The simplest workaround for this at the moment is to use leader-hjkl for pane navigation
    -- This overwrites the defaultish map for debug navigation, so we put it at g for now
    -- for consistency. If we can make ctrl-hjkl work for navigation on Windows, this should be
    -- changed back to its default of l
    { key = "g", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
    -- Don't pass obnoxious key codes
    { key = "J", mods = "CTRL|SHIFT", action = wezterm.action.Nop },
    { key = "H", mods = "CTRL|SHIFT", action = wezterm.action.Nop },
    { key = "Z", mods = "CTRL|SHIFT", action = wezterm.action.Nop },
}

local purp_text = "#d598ff"
local purp_bg = "#2b2233"
local cyan_text = "#98fffb"
local yellow_text = "#edff98"

wezterm.on("gui-startup", function()
    local tab1, _, window = wezterm.mux.spawn_window({ cwd = wezterm.home_dir })
    local _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/obsidian/main" })
    local _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/.config/nvim" })
    local _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/programming" })
    local _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/programming/yaps/" })
    local _, _ = window:spawn_tab({
        cwd = wezterm.home_dir .. "/programming/code_challenges/advent_of_code/",
    })
    local _, _ = window:spawn_tab({ cwd = wezterm.home_dir .. "/programming/nvim_plugin_dev" })

    tab1:activate()
end)

config.colors = {
    foreground = "#EEEEEC",
    background = "black",
    cursor_border = "#EEEEEC",
    split = purp_text,
    ansi = {
        "black",
        "#9C5467",
        "#7C509B",
        "#916D3F",
        "#459B97",
        "#5E8F3F",
        "#9EAD54",
        "silver",
    },
    brights = {
        "grey",
        "#FF98B3",
        purp_text,
        "#FFD298",
        cyan_text,
        "#C0FF98",
        yellow_text,
        "#EEEEEC",
    },
    tab_bar = {
        background = purp_bg,

        active_tab = {
            bg_color = "#6a4c7f",
            fg_color = purp_text,
            intensity = "Bold",
        },

        inactive_tab = {
            bg_color = purp_bg,
            fg_color = purp_text,
        },

        inactive_tab_hover = {
            bg_color = "#4c7f7d",
            fg_color = cyan_text,
        },

        new_tab = {
            bg_color = purp_bg,
            fg_color = purp_text,
        },

        new_tab_hover = {
            bg_color = "#4c7f7d",
            fg_color = cyan_text,
        },
    },
}

config.status_update_interval = 5000

wezterm.on("update-status", function(window, _)
    local elements = {}

    if window:leader_is_active() then
        table.insert(elements, { Background = { Color = "#767f4c" } })
        table.insert(elements, { Foreground = { Color = yellow_text } })
        table.insert(elements, { Text = " LDR " })
    end

    local tab = window:active_tab()
    local panes = tab:panes_with_info()
    local is_zoomed = false
    for _, p in ipairs(panes) do
        if p.is_active and p.is_zoomed then
            is_zoomed = true
        end
    end

    if is_zoomed then
        table.insert(elements, { Background = { Color = "#4c7f7d" } })
        table.insert(elements, { Foreground = { Color = cyan_text } })
        table.insert(elements, { Text = " ZOOM " })
    end

    local datetime = wezterm.strftime("%Y-%m-%d %H:%M:%S")
    table.insert(elements, { Background = { Color = purp_bg } })
    table.insert(elements, { Foreground = { Color = purp_text } })
    table.insert(elements, { Text = " " .. datetime .. " " })

    window:set_right_status(wezterm.format(elements))
end)

return config

-- Unused snippets:

-- config.debug_key_events = true

-- config.window_frame = {
--     font = wezterm.font("Cousine Nerd Font Mono", { weight = "Bold" }),
--     font_size = font_size,
-- }

-- config.window_decorations = "RESIZE"

-- config.front_end = "OpenGL"

-- local _, _ = window:spawn_tab({
--     cwd = wezterm.home_dir .. "/programming/learning/rust_reference/",
-- })

-- local _, _ = window:spawn_tab({
--     cwd = wezterm.home_dir .. "/default_programming_files",
-- })
