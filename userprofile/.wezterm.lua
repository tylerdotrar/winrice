-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the Terminal Configuration.
local config = wezterm.config_builder()

-- Variables for Easier Testing
-- Note: Color Scheme Reference --> https://wezterm.org/colorschemes/index.html
local colorScheme1 = "s3r0 modified (terminal.sexy)"
local colorScheme2 = "Default (dark) (terminal.sexy)"
local fontStyle = "JetBrainsMono Nerd Font"
local defaultShell = "pwsh.exe" -- Note: use full binary path IF this results in a 32-bit shell.

-- Rendering
config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

-- Sizing and Fonts
config.font = wezterm.font(fontStyle, { weight = "Bold" })
config.font_size = 12
config.cell_width = 0.8
config.prefer_egl = true
config.window_background_opacity = 0.8
config.window_padding = {
	left = 10,
	right = 10,
	top = 5,
	bottom = 5,
}

-- Default Color Scheme
config.color_scheme = colorScheme1

-- Default Terminal Process
config.default_prog = { defaultShell, "-NoLogo" }
config.window_decorations = "NONE | RESIZE"
config.initial_cols = 80

-- Toggle Color Scheme Function
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == colorScheme2 then
		overrides.color_scheme = colorScheme1
	else
		overrides.color_scheme = colorScheme2
	end
	window:set_config_overrides(overrides)
end)

-- Toggle Opacity Function
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if overrides.window_background_opacity == 0.9 then
		overrides.window_background_opacity = 0.8
	else
		overrides.window_background_opacity = 0.9
	end
	window:set_config_overrides(overrides)
end)

-- Enable Enhanced Dragging with GlazeWM
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SHIFT|ALT",
		action = wezterm.action.StartWindowDrag,
	},
}

-- Custom Key Bindings
config.keys = {
	-- Toggle Color Scheme
	{
		key = "P",
		mods = "SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	-- Toggle Opacity
	{
		key = "O",
		mods = "SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
	-- Dont really use any of these with GlazeWM tbh
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
}

-- Tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Return the Configuration to Wezterm
return config
