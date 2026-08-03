{
  config,
  lib,
  pkgs,
  pkgs-stable ? pkgs,
  machineName,
  userSettings,
  ...
}:

let
  theme = config.colorScheme.palette;
  homeDir = "/home/${userSettings.name}";
  isNvidia = machineName == "home-desktop";

  monitorSpec =
    if machineName == "home-desktop" then
      "HDMI-A-1,2560x1080@60,0x0,1"
    else
      ",preferred,auto,1";

  kbLayout = "us,br";
  kbVariant = "intl,abnt2";
  kbOptions = "grp:win_space_toggle,compose:rctrl";

  terminal = userSettings.term;
  browser = userSettings.browser;
  editor = userSettings.editor;
  wallpaper = "${userSettings.wallpaperDir}/battery-gruvbox.png";

  polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

  hyprlandNested = pkgs.writeShellScriptBin "hyprland-nested" ''
    set -euo pipefail

    # Testa o Hyprland dentro da sessão GNOME/Wayland atual.
    # Usa a configuração real gerada pelo Home Manager.
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland

    exec ${pkgs.hyprland}/bin/Hyprland --config "$HOME/.config/hypr/hyprland.conf"
  '';

  hyprlandNestedSafe = pkgs.writeShellScriptBin "hyprland-nested-safe" ''
    set -euo pipefail

    # Sessão aninhada mínima, sem quickshell, wallpaper, polkit etc.
    # Serve para verificar se o compositor abre dentro do GNOME.
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland

    exec ${pkgs.hyprland}/bin/Hyprland --config "$HOME/.config/hypr/hyprland-nested.conf"
  '';

  morningMessages = pkgs.writeShellScriptBin "morning-messages" ''
    set -euo pipefail

    exec ${pkgs-stable.brave}/bin/brave --new-window \
      "https://calendar.google.com/calendar/u/1/r/week" \
      "https://mail.google.com/mail/u/1/#inbox" \
      "https://web.whatsapp.com/" \
      "https://mail.google.com/mail/u/0/#inbox"
  '';

  llmDashboards = pkgs.writeShellScriptBin "llm-dashboards" ''
    set -euo pipefail

    exec ${pkgs-stable.brave}/bin/brave --new-window \
      "http://100.83.180.41:9119/models" \
      "https://ollama.com/settings" \
      "https://chatgpt.com/codex/cloud/settings/analytics" \
      "https://openrouter.ai/activity"
  '';

  screenshotFull = pkgs.writeShellScriptBin "screenshot-full" ''
    set -euo pipefail

    screenshot_dir="$HOME/Pictures/Screenshots"
    mkdir -p "$screenshot_dir"
    output="$screenshot_dir/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

    ${pkgs.grim}/bin/grim "$output"
    ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$output"
    ${pkgs.libnotify}/bin/notify-send "Captura de tela salva" "$output"
  '';

  screenshotArea = pkgs.writeShellScriptBin "screenshot-area" ''
    set -euo pipefail

    geometry="$(${pkgs.slurp}/bin/slurp)" || exit 0
    [ -n "$geometry" ] || exit 0

    screenshot_dir="$HOME/Pictures/Screenshots"
    mkdir -p "$screenshot_dir"
    output="$screenshot_dir/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

    ${pkgs.grim}/bin/grim -g "$geometry" "$output"
    ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$output"
    ${pkgs.libnotify}/bin/notify-send "Captura de área salva" "$output"
  '';
in
{
  imports = [
    ./rofi.nix
    ./quickshell.nix
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

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
      brightnessctl
      wireplumber
      polkit_gnome
    ])
    ++ [
      hyprlandNested
      hyprlandNestedSafe
      morningMessages
      llmDashboards
      screenshotFull
      screenshotArea
    ]
    ++ (with pkgs-stable; [ ]);

  home.file = {
    ".config/zaney-stinger.mov".source = ../resources/zaney-stinger.mov;
    ".base16-themes".source = ../resources/base16-themes;
    ".face".source = ../resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ../resources/rofi-gruvbox.jpg;
  };

  # Configuração mínima para testar Hyprland aninhado dentro do GNOME.
  # Rode com: hyprland-nested-safe
  xdg.configFile."hypr/hyprland-nested.conf".text = ''
    # Sessões aninhadas expõem um monitor virtual, independentemente do host.
    monitor = ,preferred,auto,1

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = QT_QPA_PLATFORM,wayland
    env = MOZ_ENABLE_WAYLAND,1
    env = XCOMPOSEFILE,${homeDir}/.XCompose
    env = GTK_IM_MODULE,cedilla
    env = QT_IM_MODULE,cedilla

    general {
      gaps_in = 3
      gaps_out = 3
      border_size = 1
      col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) 45deg
      col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
      layout = dwindle
      resize_on_border = true
    }

    input {
      kb_layout = ${kbLayout}
      kb_variant = ${kbVariant}
      kb_options = ${kbOptions}
      follow_mouse = 1
      sensitivity = 0

      touchpad {
        natural_scroll = false
      }
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      force_default_wallpaper = 0
    }

    decoration {
      rounding = 6
    }

    dwindle {
      preserve_split = true
      force_split = 2
    }

    bind = SUPER, RETURN, exec, ${terminal}
    bind = SUPER SHIFT, K, killactive
    bind = SUPER, F, fullscreen
    bind = SUPER, W, togglefloating
    bind = SUPER SHIFT, R, exec, hyprctl reload
    bind = SUPER CTRL SHIFT, C, exit

    bind = SUPER, LEFT, movefocus, l
    bind = SUPER, RIGHT, movefocus, r
    bind = SUPER, UP, movefocus, u
    bind = SUPER, DOWN, movefocus, d

    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    # Evita a geração de hyprland.lua e volta para hyprland.conf.
    # É a opção mais robusta enquanto sua configuração Lua está instável.
    configType = "hyprlang";

    settings = {
      monitor = [ monitorSpec ];

      env =
        [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "CLUTTER_BACKEND,wayland"
          "QT_QPA_PLATFORM,wayland"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "MOZ_ENABLE_WAYLAND,1"
          "GTK_THEME,Gruvbox-Dark"
          "XCOMPOSEFILE,${homeDir}/.XCompose"
          "GTK_IM_MODULE,cedilla"
          "QT_IM_MODULE,cedilla"
          "XDG_CONFIG_HOME,${homeDir}/.config"
          "DOOMLOCALDIR,${homeDir}/.config/doom-local"
          "DOOMDIR,${homeDir}/.config/doom-config"
        ]
        ++ lib.optionals isNvidia [
          "LIBVA_DRIVER_NAME,nvidia"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
        ];

      general = {
        gaps_in = 3;
        gaps_out = 3;
        border_size = 1;
        "col.active_border" = "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) 45deg";
        "col.inactive_border" = "rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg";
        layout = "dwindle";
        resize_on_border = true;
      };

      input = {
        kb_layout = kbLayout;
        kb_variant = kbVariant;
        kb_options = kbOptions;
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 6;

        blur = {
          enabled = true;
          size = 6;
          passes = if isNvidia then 2 else 1;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.02;
          contrast = 0.9;
        };
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];

      animation = [
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 1, liner"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
      ];

      exec-once = [
        polkitAgent
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "awww-daemon"
        "awww img ${wallpaper} --transition-type wipe"
        "quickshell"
      ];

      bind = [
        # Quickshell controles
        "SUPER SHIFT, P, exec, qs ipc call launcher toggle"
        # SUPER+SHIFT+L passou a abrir os painéis LLM; a barra foi movida
        # para SUPER+ALT+L para evitar sobreposição.
        "SUPER ALT, L, exec, qs ipc call bar toggle"
        "SUPER, N, exec, qs ipc call notifications dismiss_all"
        "SUPER SHIFT, N, exec, qs ipc call notifications dnd_toggle"
        "SUPER, M, exec, qs ipc call media toggle"
        ", XF86AudioPlay, exec, qs ipc call media play_pause"

        # No seu arquivo havia conflito: SUPER+W era usado para wallpaper
        # e também para togglefloating. Mantive SUPER+W para floating e
        # movi wallpaper para SUPER+ALT+W.
        "SUPER ALT, W, exec, qs ipc call wallpaper toggle"

        # Programas
        "SUPER, RETURN, exec, ${terminal}"
        # O binário instalado pelo pacote oficial chama-se Telegram (T maiúsculo).
        "SUPER SHIFT, T, exec, [workspace 10] Telegram"
        "SUPER SHIFT, M, exec, [workspace 2] ${morningMessages}/bin/morning-messages"
        "SUPER SHIFT, L, exec, [workspace 8] ${llmDashboards}/bin/llm-dashboards"
        "SUPER SHIFT, B, exec, ${browser}"
        "SUPER SHIFT, E, exec, ${editor}"
        "SUPER SHIFT, Z, exec, zotero"
        "SUPER SHIFT, F, exec, nautilus"

        # Capturas: Print salva a tela inteira; Shift+Print seleciona uma área.
        # SUPER+S permanece como alias da captura de área.
        ", Print, exec, ${screenshotFull}/bin/screenshot-full"
        "SHIFT, Print, exec, ${screenshotArea}/bin/screenshot-area"
        "SUPER, S, exec, ${screenshotArea}/bin/screenshot-area"

        # Scripts
        "SUPER SHIFT, O, exec, emopicker"
        "SUPER SHIFT, X, exec, powermenu"

        # Funções do Hyprland
        "SUPER SHIFT, K, killactive"
        "SUPER, P, pseudo"
        #        "SUPER SHIFT, I, togglesplit"
        "SUPER, F, fullscreen"
        "SUPER, W, togglefloating"
        # Exige três modificadores para evitar encerramento acidental da sessão.
        "SUPER CTRL SHIFT, C, exit"
        "SUPER SHIFT, R, exec, hyprctl reload"

        # Mover janela
        "SUPER SHIFT, LEFT, movewindow, l"
        "SUPER SHIFT, RIGHT, movewindow, r"
        "SUPER SHIFT, UP, movewindow, u"
        "SUPER SHIFT, DOWN, movewindow, d"

        # Foco
        "SUPER, LEFT, movefocus, l"
        "SUPER, RIGHT, movefocus, r"
        "SUPER, UP, movefocus, u"
        "SUPER, DOWN, movefocus, d"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        # Teclas multimídia
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      binde = [
        "SUPER CTRL, RIGHT, resizeactive, 100 0"
        "SUPER CTRL, LEFT, resizeactive, -100 0"
        "SUPER CTRL, UP, resizeactive, 0 -175"
        "SUPER CTRL, DOWN, resizeactive, 0 175"
      ];
    };
  };
}
