-- Personal layer: loaded after the Serpantinum defaults.
-- Keep workstation-specific behavior here so it is easy to review and restore.

-- Remove arrow-based window controls and the conflicting Meta+L lock bind.
for _, keys in ipairs({
  "SUPER + Left", "SUPER + Right", "SUPER + Up", "SUPER + Down",
  "SUPER + SHIFT + Left", "SUPER + SHIFT + Right", "SUPER + SHIFT + Up", "SUPER + SHIFT + Down",
  "SUPER + CTRL + Left", "SUPER + CTRL + Right", "SUPER + CTRL + Up", "SUPER + CTRL + Down",
  "SUPER + CTRL + SHIFT + Left", "SUPER + CTRL + SHIFT + Right", "SUPER + CTRL + SHIFT + Up", "SUPER + CTRL + SHIFT + Down",
  "SUPER + H", "SUPER + L",
}) do
  hl.unbind(keys)
end

-- Serpantinum binds numbered workspaces globally. Replace them with slots that
-- resolve against the focused monitor: 1-10 on the notebook, 11-20 on HDMI.
local local_bin = "/home/kaue/.local/bin/"

-- Visual slots are identical on both monitors; IDs differ only internally.
-- Keep these roles aligned with the Serpantinum workspace widget.
local workspace_roles = {
  [1] = "principal",
  [2] = "navegador",
  [3] = "código",
  [4] = "terminal",
  [9] = "OBS",
  [10] = "jogo",
}
for i = 1, 10 do
  local key = tostring(i % 10)
  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
end

hl.unbind("XF86AudioRaiseVolume")
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(local_bin .. "hypr-volume-raise"), { repeating = true, locked = true })

hl.config({
  input = {
    numlock_by_default = true,
    accel_profile = "flat",
    sensitivity = 0.4,
  },

  general = {
    layout = "master",
    border_size = 1,
    gaps_in = 6,
    gaps_out = 10,
    float_gaps = 10,
    allow_tearing = true,
    col = {
      active_border = "rgba(8b5cb980)",
      inactive_border = "rgba(2b223340)",
    },
  },

  decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 0.97,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
    },
  },

  master = {
    mfact = 0.62,
    new_status = "slave",
    new_on_top = true,
    always_keep_position = true,
    focus_master_on_close = true,
  },

  misc = {
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
  },
})

-- Serpantinum uses speed 5 globally; workspaces benefit from a calmer transition.
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "myBezier", style = "slide" })

-- Two independent-looking workspace banks. Hyprland IDs remain global, but
-- Super+1..0 selects the matching slot of the monitor that currently has focus.
for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = i == 1, persistent = true, layout = "master" })
  hl.workspace_rule({ workspace = tostring(i + 10), monitor = "HDMI-A-1", default = i == 1, persistent = true, layout = "monocle" })
end

-- Smart gaps: a sole tiled window owns the usable monitor area without gaps,
-- borders or rounding, while retaining the bar and normal window-management.
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.window_rule({
  name = "single-tiled-window-full-area",
  match = { float = false, workspace = "w[tv1]" },
  border_size = 0,
  rounding = 0,
})


-- Open stream control and the game in predictable places.
hl.window_rule({ name = "obs-on-notebook", match = { class = "com.obsproject.Studio" }, workspace = "9" })
hl.window_rule({ name = "cs2-on-external", match = { class = "cs2" }, workspace = "20", immediate = true })
hl.window_rule({ name = "floorp-on-notebook", match = { class = ".*[Ff]loorp.*" }, workspace = "2" })
hl.window_rule({
  name = "reaper-main-fullscreen",
  match = {
    class = "^(REAPER)$",
    title = ".*REAPER v.*",
  },
  tile = true,
  fullscreen = true,
})

-- Small utility windows should not disrupt the master layout.
for _, rule in ipairs({
  { name = "file-chooser-float", class = ".*(filechooser|FileChooser|kdialog|zenity).*" },
  { name = "calculator-float", class = ".*(kcalc|qalculate|Calculator).*" },
  { name = "volume-float", class = ".*(pavucontrol|easyeffects).*" },
}) do
  hl.window_rule({ name = rule.name, match = { class = rule.class }, float = true, center = true })
end

-- File manager: floating Yazi window
hl.window_rule({
  name = "yazi-float",
  match = { class = "yazi-float" },
  float = true,
  center = true,
  size = { "80%", "80%" },
})

-- Scratchpads stay outside the numbered workspaces and toggle over any workspace.
hl.window_rule({
  name = "scratch-terminal",
  match = { class = "hypr-scratch-terminal" },
  workspace = "special:terminal",
  float = true,
  -- Full-monitor utility surface; opacity keeps the workspace faintly visible.
  size = { "monitor_w", "monitor_h" },
  center = true,
  opacity = 0.94,
})

hl.window_rule({
  name = "scratch-btop",
  match = { class = "hypr-scratch-btop" },
  workspace = "special:btop",
  float = true,
  size = { "monitor_w", "monitor_h" },
  center = true,
  opacity = 0.94,
})

local function toggle_scratchpad(name, command)
  local workspace = "special:" .. name
  local windows = hl.get_workspace_windows(workspace) or {}
  hl.dispatch(hl.dsp.workspace.toggle_special(name))
  if #windows == 0 then
    hl.exec_cmd(command)
  end
end

hl.bind("SUPER + CTRL + SPACE", function()
  toggle_scratchpad("terminal", "ghostty --class=hypr-scratch-terminal")
end)

hl.bind("SUPER + CTRL + B", function()
  toggle_scratchpad("btop", "ghostty --class=hypr-scratch-btop -e btop")
end)

-- Workspace slots run inside Hyprland itself: 1..10 on eDP-1 and 11..20 on
-- HDMI-A-1. This deliberately avoids external commands for core navigation.
local function workspace_for_monitor(slot, monitor_name)
  if monitor_name == "HDMI-A-1" then
    return slot + 10
  end
  return slot
end

local function use_workspace_slot(slot, move_window)
  local monitor = hl.get_active_monitor()
  local workspace = workspace_for_monitor(slot, monitor and monitor.name or "eDP-1")
  if move_window then
    hl.dispatch(hl.dsp.window.move({ workspace = tostring(workspace) }))
  else
    hl.dispatch(hl.dsp.focus({ workspace = tostring(workspace) }))
  end
end

for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind("SUPER + " .. key, function()
    use_workspace_slot(i, false)
  end)
  hl.bind("SUPER + SHIFT + " .. key, function()
    use_workspace_slot(i, true)
  end)
end

-- Exchange the most recently focused normal window on each monitor.
hl.bind("SUPER + CTRL + X", hl.dsp.exec_cmd(local_bin .. "hypr-swap-monitors"))

-- Reassert the game/stream arrangement without touching performance or power.
hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd(local_bin .. "hypr-game-stream-mode"))
hl.bind("SUPER + CTRL + D", hl.dsp.exec_cmd(local_bin .. "hypr-development-mode"))
hl.bind("SUPER + CTRL + F", hl.dsp.exec_cmd(local_bin .. "hypr-focus-mode"))
hl.bind("SUPER + CTRL + ALT + SPACE", hl.dsp.exec_cmd(local_bin .. "hypr-quick-actions"))
hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.exec_cmd(local_bin .. "hypr-window-overview"))
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd(local_bin .. "hypr-presentation-mode"))
hl.bind("SUPER + CTRL + SHIFT + M", hl.dsp.exec_cmd(local_bin .. "hypr-audio-context"))
hl.bind("SUPER + CTRL + ALT + C", hl.dsp.exec_cmd(local_bin .. "hypr-control-center"))


-- Send the focused window to the matching visual slot on the left (notebook) or
-- right (HDMI) monitor, retaining the KDE-style two-bank mental model.
local function send_window_to_monitor(monitor_name)
  local workspace = hl.get_active_workspace()
  if not workspace or workspace.id < 1 then
    return
  end

  local slot = workspace.id > 10 and workspace.id - 10 or workspace.id
  hl.dispatch(hl.dsp.window.move({ workspace = tostring(workspace_for_monitor(slot, monitor_name)) }))
end

hl.bind("SUPER + SHIFT + U", function()
  send_window_to_monitor("eDP-1")
end)
hl.bind("SUPER + SHIFT + I", function()
  send_window_to_monitor("HDMI-A-1")
end)

-- Master layout controls.
hl.bind("SUPER + CTRL + RETURN", hl.dsp.layout("swapwithmaster master"))
hl.bind("SUPER + CTRL + ALT + H", hl.dsp.layout("mfact -0.04"), { repeating = true })
hl.bind("SUPER + CTRL + ALT + L", hl.dsp.layout("mfact +0.04"), { repeating = true })

-- Vim-style focus, window movement and workspace navigation.
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind("SUPER + CTRL + H", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CTRL + J", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + CTRL + K", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ workspace = "m+1" }))

hl.bind("SUPER + CTRL + SHIFT + H", hl.dsp.window.move({ workspace = "m-1" }))
hl.bind("SUPER + CTRL + SHIFT + J", hl.dsp.window.move({ workspace = "m+1" }))
hl.bind("SUPER + CTRL + SHIFT + K", hl.dsp.window.move({ workspace = "m-1" }))
hl.bind("SUPER + CTRL + SHIFT + L", hl.dsp.window.move({ workspace = "m+1" }))

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("serpantinum lock"), { locked = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("/home/kaue/.local/bin/hypr-lid-switch close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("/home/kaue/.local/bin/hypr-lid-switch open"), { locked = true })

-- Grouped windows: a tabbed container for related terminals or utilities.
hl.bind("SUPER + CTRL + G", hl.dsp.group.toggle())
hl.bind("SUPER + ALT + H", hl.dsp.group.prev())
hl.bind("SUPER + ALT + L", hl.dsp.group.next())
hl.bind("SUPER + CTRL + ALT + SHIFT + H", hl.dsp.window.move({ into_or_create_group = "l" }))
hl.bind("SUPER + CTRL + ALT + SHIFT + L", hl.dsp.window.move({ into_or_create_group = "r" }))

-- Keyboard resize for floating windows; tiled windows remain layout-managed.
hl.bind("SUPER + ALT + SHIFT + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + SHIFT + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
