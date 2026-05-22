{
  config,
  lib,
  pkgs,
  pkgs-stable ? pkgs,
  userSettings,
  ...
}:

let
  theme = config.colorScheme.palette;

  lua = lib.generators.mkLuaInline;

  execCmd = command: lua "hl.dsp.exec_cmd(${builtins.toJSON command})";
  dispatchCmd =
    dispatcher: arg: "hyprctl dispatch ${dispatcher}${lib.optionalString (arg != "") " ${arg}"}";

  bindExec = key: command: {
    _args = [
      key
      (execCmd command)
    ];
  };

  bindDispatch =
    key: dispatcher: arg:
    bindExec key (dispatchCmd dispatcher arg);

  bindRepeatDispatch = key: dispatcher: arg: {
    _args = [
      key
      (execCmd (dispatchCmd dispatcher arg))
      { repeating = true; }
    ];
  };
in
{
  imports = [
    ./rofi.nix
    ./quickshell.nix
    ./bin/powermenu.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Conteúdo consolidado de pkgs-hyprland.nix.
  home.packages =
    (with pkgs; [
      awww
      grim
      slurp
      wl-clipboard
      ydotool
      xhost
      wev
      nautilus
      hyprlock
    ])
    ++ (with pkgs-stable; [ ]);

  home.file = {
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi-gruvbox.jpg;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    configType = "lua";

    settings = {
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "2569x1080@60";
          position = "0x0";
          scale = 1;
        }
      ];

      env = [
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "CLUTTER_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "GTK_THEME,Gruvbox-Dark"
        "XCOMPOSEFILE,/home/andre/.XCompose"
        "GTK_IM_MODULE,cedilla"
        "QT_IM_MODULE,cedilla"
        "XDG_CONFIG_HOME,/home/andre/.config"
        "DOOMLOCALDIR,/home/andre/.config/doom-local"
        "DOOMDIR,/home/andre/.config/doom-config"
      ];

      # Em configType = "lua", opções do Hyprland devem ficar dentro de
      # hl.config({...}); se ficarem como atributos de topo, o Home Manager
      # gera chamadas inexistentes como hl.general({...}).
      #      config = {
      #        general = {
      #          gaps_in = 3;
      #          gaps_out = 3;
      #          border_size = 1;
      #          "col.active_border" = "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) 45deg";
      #          "col.inactive_border" = "rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg";
      #          layout = "dwindle";
      #          resize_on_border = true;
      #        };
      #
      #        input = {
      #          kb_layout = "us,br";
      #          kb_variant = "intl,abnt2";
      #          kb_options = "grp:alt_shift_toggle,compose:rctrl";
      #          follow_mouse = 1;
      #          sensitivity = 0;
      #          touchpad.natural_scroll = false;
      #        };
      #
      #        misc = {
      #          mouse_move_enables_dpms = true;
      #          key_press_enables_dpms = false;
      #          disable_hyprland_logo = true;
      #          disable_splash_rendering = true;
      #          force_default_wallpaper = 0;
      #        };
      #
      #        animations.enabled = true;
      #
      #        decoration = {
      #          rounding = 6;
      #          blur = {
      #            enabled = true;
      #            size = 6;
      #            passes = 3;
      #            new_optimizations = true;
      #            ignore_opacity = true;
      #            noise = 0.02;
      #            contrast = 0.9;
      #          };
      #        };
      #
      #        dwindle = {
      #          pseudotile = true;
      #          preserve_split = true;
      #          force_split = 2;
      #        };
      #      };
      #
      # Hyprland 0.55+ Lua API espera tabela para curvas/animações.
      # A forma posicional antiga gerava 12 chamadas inválidas do tipo
      # hl.curve("...") / hl.animation("...").
      curve = [
        {
          _args = [
            "wind"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.05
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "winIn"
            {
              type = "bezier";
              points = [
                [
                  0.1
                  1.1
                ]
                [
                  0.1
                  1.1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "winOut"
            {
              type = "bezier";
              points = [
                [
                  0.3
                  (-0.3)
                ]
                [
                  0
                  1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "liner"
            {
              type = "bezier";
              points = [
                [
                  1
                  1
                ]
                [
                  1
                  1
                ]
              ];
            }
          ];
        }
      ];

      animation = [
        {
          _args = [
            {
              leaf = "windows";
              enabled = true;
              speed = 6;
              bezier = "wind";
              style = "slide";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "windowsIn";
              enabled = true;
              speed = 6;
              bezier = "winIn";
              style = "slide";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 5;
              bezier = "winOut";
              style = "slide";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "windowsMove";
              enabled = true;
              speed = 5;
              bezier = "wind";
              style = "slide";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "border";
              enabled = true;
              speed = 1;
              bezier = "liner";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "borderangle";
              enabled = true;
              speed = 30;
              bezier = "liner";
              style = "loop";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "fade";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
          ];
        }
        {
          _args = [
            {
              leaf = "workspaces";
              enabled = true;
              speed = 5;
              bezier = "wind";
            }
          ];
        }
      ];

      bind = [
        # Quickshell controles
        (bindExec "SUPER + SHIFT + P" "qs ipc call launcher toggle")
        (bindExec "SUPER + SHIFT + L" "qs ipc call bar toggle")
        (bindExec "SUPER + N" "qs ipc call notifications dismiss_all")
        (bindExec "SUPER + SHIFT + N" "qs ipc call notifications dnd_toggle")
        (bindExec "SUPER + M" "qs ipc call media toggle")
        (bindExec "XF86AudioPlay" "qs ipc call media play_pause")
        (bindExec "SUPER + W" "qs ipc call wallpaper toggle")

        # Programas
        (bindExec "SUPER + RETURN" userSettings.term)
        (bindExec "SUPER + S" ''grim -g "$(slurp)"'')
        (bindExec "SUPER + SHIFT + B" userSettings.browser)
        (bindExec "SUPER + SHIFT + E" userSettings.editor)
        (bindExec "SUPER + SHIFT + Z" "zotero")
        (bindExec "SUPER + SHIFT + F" "nautilus")

        # Scripts
        (bindExec "SUPER + SHIFT + O" "emopicker")
        (bindExec "SUPER + SHIFT + X" "powermenu")

        # Funções do Hyprland, preservadas via hyprctl dispatch.
        (bindDispatch "SUPER + SHIFT + K" "killactive" "")
        (bindDispatch "SUPER + P" "pseudo" "")
        (bindDispatch "SUPER + SHIFT + I" "togglesplit" "")
        (bindDispatch "SUPER + F" "fullscreen" "")
        (bindDispatch "SUPER + W" "togglefloating" "")
        (bindDispatch "SUPER + SHIFT + C" "exit" "")
        (bindExec "SUPER + SHIFT + R" "hyprctl reload")

        # Mover janela
        (bindDispatch "SUPER + SHIFT + LEFT" "movewindow" "l")
        (bindDispatch "SUPER + SHIFT + RIGHT" "movewindow" "r")
        (bindDispatch "SUPER + SHIFT + UP" "movewindow" "u")
        (bindDispatch "SUPER + SHIFT + DOWN" "movewindow" "d")

        # Foco
        (bindDispatch "SUPER + LEFT" "movefocus" "l")
        (bindDispatch "SUPER + RIGHT" "movefocus" "r")
        (bindDispatch "SUPER + UP" "movefocus" "u")
        (bindDispatch "SUPER + DOWN" "movefocus" "d")

        # Workspaces
        (bindDispatch "SUPER + 1" "workspace" "1")
        (bindDispatch "SUPER + 2" "workspace" "2")
        (bindDispatch "SUPER + 3" "workspace" "3")
        (bindDispatch "SUPER + 4" "workspace" "4")
        (bindDispatch "SUPER + 5" "workspace" "5")
        (bindDispatch "SUPER + 6" "workspace" "6")
        (bindDispatch "SUPER + 7" "workspace" "7")
        (bindDispatch "SUPER + 8" "workspace" "8")
        (bindDispatch "SUPER + 9" "workspace" "9")
        (bindDispatch "SUPER + 0" "workspace" "10")
        (bindDispatch "SUPER + SHIFT + 1" "movetoworkspace" "1")
        (bindDispatch "SUPER + SHIFT + 2" "movetoworkspace" "2")
        (bindDispatch "SUPER + SHIFT + 3" "movetoworkspace" "3")
        (bindDispatch "SUPER + SHIFT + 4" "movetoworkspace" "4")
        (bindDispatch "SUPER + SHIFT + 5" "movetoworkspace" "5")
        (bindDispatch "SUPER + SHIFT + 6" "movetoworkspace" "6")
        (bindDispatch "SUPER + SHIFT + 7" "movetoworkspace" "7")
        (bindDispatch "SUPER + SHIFT + 8" "movetoworkspace" "8")
        (bindDispatch "SUPER + SHIFT + 9" "movetoworkspace" "9")
        (bindDispatch "SUPER + SHIFT + 0" "movetoworkspace" "10")
        (bindDispatch "SUPER + mouse_down" "workspace" "e+1")
        (bindDispatch "SUPER + mouse_up" "workspace" "e-1")

        # Mouse: equivalente aos bindm antigos, usando o despachante Lua.
        {
          _args = [
            "SUPER + mouse:272"
            (lua "hl.dsp.window.drag(\"move\")")
            { drag = true; }
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lua "hl.dsp.window.drag(\"resize\")")
            { drag = true; }
          ];
        }

        # Binds repetíveis para redimensionar a janela ativa. No configType
        # Lua, não use a chave `binde`, pois ela viraria hl.binde(...), que
        # não existe na API Lua atual; use hl.bind(..., { repeating = true }).
        (bindRepeatDispatch "SUPER + CTRL + RIGHT" "resizeactive" "100 0")
        (bindRepeatDispatch "SUPER + CTRL + LEFT" "resizeactive" "-100 0")
        (bindRepeatDispatch "SUPER + CTRL + UP" "resizeactive" "0 -175")
        (bindRepeatDispatch "SUPER + CTRL + DOWN" "resizeactive" "0 175")

        # Teclas multimídia
        (bindExec "XF86AudioRaiseVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
        (bindExec "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        (bindExec "XF86MonBrightnessDown" "brightnessctl set 5%-")
        (bindExec "XF86MonBrightnessUp" "brightnessctl set +5%")
      ];
    };

    # Substitui o antigo exec-once: essa chave vira hl.exec-once(...) em Lua,
    # que é sintaxe inválida. Em Lua, use hl.on("hyprland.start", ...).
    extraConfig = ''
      -- Aplicações iniciadas uma vez no começo da sessão Hyprland.
      hl.on("hyprland.start", function()
        hl.exec_cmd("$POLKIT_BIN")
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")
        hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("awww img ${userSettings.wallpaperDir}/battery-gruvbox.png --transition-type wipe")
        hl.exec_cmd("quickshell")
      end)
    '';
  };
}
