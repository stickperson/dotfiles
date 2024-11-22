local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Nord (base16)"
-- config.color_scheme = "Catppuccin Frappe"
-- config.color_scheme = "onenord"
config.color_scheme = "JetBrains Darcula"
-- config.color_scheme = "Tokyo Night (Gogh)"
-- config.color_scheme = "Tokyo Night"

config.font = wezterm.font("Hack Nerd Font Mono", {})
config.font_size = 12

-- config.hide_tab_bar_if_only_one_tab = true

-- wezterm.on("update-right-status", function(window, _)
-- 	local _, stdout, stderr = wezterm.run_child_process({
-- 		"osascript",
-- 		"-e",
-- 		[[
--         if application "Spotify" is running then
--           tell application "Spotify"
--             set playerState to (get player state) as text
--             set artistTrack to (get artist of current track) & " - " & (get name of current track)
--             if playerState contains "playing" then
--               set icon to "  "
--             else if playerState = "paused" then
--               set icon to "  "
--             else
--               set icon to "  "
--             end if
--           end tell
--           tell application "Spotify"
--             return icon & artistTrack
--           end tell
--         else
--           return ""
--         end if
--       ]],
-- 	})
-- 	local left_status = stderr ~= "" and stderr or stdout
-- 	window:set_left_status(left_status)
-- 	window:set_right_status("")
-- end)

config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_padding = {
	left = "2%",
	right = "2%",
	top = "2%",
	bottom = "2%",
}

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Hack Nerd Font Mono" }),

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#2e3440",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#2e3440",
}

return config
