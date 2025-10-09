{ config, lib, userSettings, ... }:

let theme = config.colorScheme.palette;
in with lib; {
  imports = [
    ./waybar.nix
    ./rofi.nix
    ./swaylock.nix
    ./swaync.nix
    ./pkgs-hyprland.nix
    ./bin/powermenu.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig = let modifier = "SUPER";
    in concatStrings [''
            monitor=,highres,auto,1
            general {
              gaps_in = 6
              gaps_out = 8
              border_size = 3
              col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) 45deg
              col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
              layout = dwindle
              resize_on_border = true
            }
            input {
              kb_layout = us
      kb_variant = intl        # US-International com dead keys
        kb_options = lv3:ralt_switch,compose:rctrl
              follow_mouse = 1
              touchpad {
                natural_scroll = false
              }
              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            }

            env = NIXOS_OZONE_WL, 1

            env = XDG_CURRENT_DESKTOP, Hyprland
            env = XDG_SESSION_TYPE, wayland
            env = XDG_SESSION_DESKTOP, Hyprland
            env = CLUTTER_BACKEND, wayland
            env = SDL_VIDEODRIVER, x11
            env = QT_QPA_PLATFORM, wayland
            env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
            env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
            env = MOZ_ENABLE_WAYLAND, 1
            env = LIBVA_DRIVER_NAME,nvidia
            env = GBM_BACKEND,nvidia-drm
            env = __GLX_VENDOR_LIBRARY_NAME,nvidia
            env = WLR_NO_HARDWARE_CURSORS,1

            env = GTK_THEME, Gruvbox-Dark
            env = XCURSOR_THEME, Bibata-Modern-Ice
            env = XCURSOR_SIZE, 24
            env = HYPRCURSOR_THEME, Bibata-Modern-Ice
            env = HYPRCURSOR_SIZE, 24

            env = XDG_CONFIG_HOME,/home/andre/.config
            env = DOOMLOCALDIR,/home/andre/.config/doom-local
            env = DOOMDIR,/home/andre/.config/doom-config

            misc {
              mouse_move_enables_dpms = true
              key_press_enables_dpms = false
            }
            animations {
              enabled = yes
              bezier = wind, 0.05, 0.9, 0.1, 1.05
              bezier = winIn, 0.1, 1.1, 0.1, 1.1
              bezier = winOut, 0.3, -0.3, 0, 1
              bezier = liner, 1, 1, 1, 1
              animation = windows, 1, 6, wind, slide
              animation = windowsIn, 1, 6, winIn, slide
              animation = windowsOut, 1, 5, winOut, slide
              animation = windowsMove, 1, 5, wind, slide
              animation = border, 1, 1, liner
              animation = borderangle, 1, 30, liner, loop
              animation = fade, 1, 10, default
              animation = workspaces, 1, 5, wind
            }
            decoration {
              rounding = 6
              blur {
                  enabled = true
                  size = 5
                  passes = 3
                  new_optimizations = on
                  ignore_opacity = on
              }
            }
            exec-once = $POLKIT_BIN
            exec-once = dbus-update-activation-environment --systemd --all
            exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = hyprctl setcursor Bibata-Modern-Ice 24
            exec-once = swww init
            exec-once = swww img ${userSettings.wallpaperDir}/nord-05.png
            exec-once = waybar
            exec-once = swaync
            exec-once = swayidle -w timeout 150 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
           # exec-once = wallsetter

            exec-once = xhost +SI:localuser:${userSettings.name}
            dwindle {
              pseudotile = true
              preserve_split = true
            }
            #master {
             # new_is_master = true
            #}
            bind = ${modifier},Return,exec,${userSettings.term}
            bind = ${modifier}SHIFT,P,exec,rofi -show drun
            bind = ${modifier}SHIFT,S,exec,swaync-client -rs
            bind = ${modifier},S,exec,grim -g "$(slurp)"

            ### exec programs ###
            bind = ${modifier}SHIFT,B,exec,${userSettings.browser}
            bind = ${modifier}SHIFT,E,exec,${userSettings.editor}
            bind = ${modifier}SHIFT,Z,exec,zotero
            bind = ${modifier}SHIFT,F,exec,nautilus

            ### exec script ###
            bind = ${modifier}SHIFT,O,exec,emopicker
            bind = ${modifier}SHIFT,X,exec,powermenu

            ### functions ###
            bind = ${modifier}SHIFT,K,killactive,
            bind = ${modifier},P,pseudo,
            bind = ${modifier}SHIFT,I,togglesplit,
            bind = ${modifier},F,fullscreen,
            bind = ${modifier},W,togglefloating,
            bind = ${modifier}SHIFT,C,exit,


            # sets repeatable binds for resizing the active window
            binde=${modifier}CTRL,right,resizeactive,150 0
            binde=${modifier}CTRL,left,resizeactive,-150 0
            binde=${modifier}CTRL,up,resizeactive,0 -150
            binde=${modifier}CTRL,down,resizeactive,0 150

            ### move window ###
            bind = ${modifier}SHIFT,left,movewindow,l
            bind = ${modifier}SHIFT,right,movewindow,r
            bind = ${modifier}SHIFT,up,movewindow,u
            bind = ${modifier}SHIFT,down,movewindow,d

            bind = ${modifier},left,movefocus,l
            bind = ${modifier},right,movefocus,r
            bind = ${modifier},up,movefocus,u
            bind = ${modifier},down,movefocus,d

            bind = ${modifier},1,workspace,1
            bind = ${modifier},2,workspace,2
            bind = ${modifier},3,workspace,3
            bind = ${modifier},4,workspace,4
            bind = ${modifier},5,workspace,5
            bind = ${modifier},6,workspace,6
            bind = ${modifier},7,workspace,7
            bind = ${modifier},8,workspace,8
            bind = ${modifier},9,workspace,9
            bind = ${modifier},0,workspace,10
            bind = ${modifier}SHIFT,1,movetoworkspace,1
            bind = ${modifier}SHIFT,2,movetoworkspace,2
            bind = ${modifier}SHIFT,3,movetoworkspace,3
            bind = ${modifier}SHIFT,4,movetoworkspace,4
            bind = ${modifier}SHIFT,5,movetoworkspace,5
            bind = ${modifier}SHIFT,6,movetoworkspace,6
            bind = ${modifier}SHIFT,7,movetoworkspace,7
            bind = ${modifier}SHIFT,8,movetoworkspace,8
            bind = ${modifier}SHIFT,9,movetoworkspace,9
            bind = ${modifier}SHIFT,0,movetoworkspace,10
            bind = ${modifier},mouse_down,workspace, e+1
            bind = ${modifier},mouse_up,workspace, e-1
            bindm = ${modifier},mouse:272,movewindow
            bindm = ${modifier},mouse:273,resizewindow
            bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
            bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
    ''];
  };
}
