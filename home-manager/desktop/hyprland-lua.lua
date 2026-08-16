-- Candidato de migração para Hyprland 0.56+.
-- Os marcadores @...@ são substituídos declarativamente pelo módulo Nix.

local terminal = "@terminal@"
local browser = "@browser@"
local editor = "@editor@"
local isNvidia = "@isNvidia@" == "true"

hl.monitor({
  output = "@monitorOutput@",
  mode = "@monitorMode@",
  position = "@monitorPosition@",
  scale = tonumber("@monitorScale@"),
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GTK_THEME", "Gruvbox-Dark")
hl.env("XCOMPOSEFILE", "@homeDir@/.XCompose")
hl.env("GTK_IM_MODULE", "cedilla")
hl.env("QT_IM_MODULE", "cedilla")
hl.env("XMODIFIERS", "@im=cedilla")
hl.env("INPUT_METHOD", "cedilla")
hl.env("XDG_CONFIG_HOME", "@homeDir@/.config")
hl.env("DOOMLOCALDIR", "@homeDir@/.config/doom-local")
hl.env("DOOMDIR", "@homeDir@/.config/doom-config")

if isNvidia then
  hl.env("LIBVA_DRIVER_NAME", "nvidia")
  hl.env("GBM_BACKEND", "nvidia-drm")
  hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
end

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 3,
    border_size = 1,
    col = {
      active_border = {
        colors = { "rgba(@activeBorderA@ff)", "rgba(@activeBorderB@ff)" },
        angle = 45,
      },
      inactive_border = {
        colors = { "rgba(@inactiveBorderA@cc)", "rgba(@inactiveBorderB@cc)" },
        angle = 45,
      },
    },
    layout = "dwindle",
    resize_on_border = true,
  },

  input = {
    kb_layout = "us,br",
    kb_variant = "intl,abnt2",
    kb_options = "grp:win_space_toggle,compose:rctrl",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },

  misc = {
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },

  cursor = {
    no_hardware_cursors = isNvidia and 1 or 2,
  },

  animations = {
    enabled = true,
  },

  decoration = {
    rounding = 6,
    blur = {
      enabled = true,
      size = 6,
      passes = isNvidia and 2 or 1,
      new_optimizations = true,
      ignore_opacity = true,
      noise = 0.02,
      contrast = 0.9,
    },
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
})

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

hl.on("hyprland.start", function()
  hl.exec_cmd("@polkitAgent@")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start quickshell.service")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("awww img @wallpaper@ --transition-type wipe")
  -- O serviço é iniciado acima depois que o ambiente Wayland/D-Bus é
  -- importado e permanece supervisionado pelo systemd do usuário.
end)

-- Quickshell
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("qs ipc call bar toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("qs ipc call notifications dismiss_all"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("qs ipc call notifications dnd_toggle"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("qs ipc call media toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("qs ipc call media play_pause"))
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))

-- Programas e painéis diários
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("Telegram", { workspace = "10" }))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("morning-messages", { workspace = "2" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("llm-dashboards", { workspace = "8" }))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(editor))
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("zotero"))
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("nautilus"))

-- Capturas de tela
hl.bind("Print", hl.dsp.exec_cmd("screenshot-full"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot-area"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("screenshot-area"))

-- Scripts
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("emopicker"))
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("powermenu"))

-- Funções do compositor
hl.bind("SUPER + SHIFT + K", hl.dsp.window.close())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + CTRL + SHIFT + C", hl.dsp.exit())
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Movimento e foco
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "down" }))

-- Workspaces 1–10
for i = 1, 10 do
  local key = i % 10
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse e resize por teclado
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + LEFT", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + UP", hl.dsp.window.resize({ x = 0, y = -175, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + DOWN", hl.dsp.window.resize({ x = 0, y = 175, relative = true }), { repeating = true })

-- Multimídia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })
