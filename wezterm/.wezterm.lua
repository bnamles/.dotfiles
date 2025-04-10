-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 15

config.enable_tab_bar = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 45

config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false

config.command_palette_bg_color = "#033259"
config.command_palette_fg_color = "#CBE0F0"
config.command_palette_font_size = 19

-- keybindings
config.keys = {
	-- Move to previous word
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "b", mods = "ALT" }) },
	-- Move to next word
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "f", mods = "ALT" }) },
	-- Move to the beginning of line
	{ key = "UpArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	-- Move to the end of line
	{ key = "DownArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }) },
	-- Whole word deletion (CMD+Backspace)
	-- {
	-- 	key = "Backspace",
	-- 	mods = "CMD",
	-- 	action = wezterm.action.SendKey({
	-- 		key = "w",
	-- 		mods = "CTRL",
	-- 	}),
	-- },
	-- Whole line deletion (CMD+Backspace)
	{
		key = "Backspace",
		mods = "CMD",
		action = wezterm.action.Multiple({
			wezterm.action.SendKey({ key = "u", mods = "CTRL" }),
			wezterm.action.SendKey({ key = "k", mods = "CTRL" }),
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
