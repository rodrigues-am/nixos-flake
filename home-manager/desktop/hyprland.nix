{
  config,
  lib,
  pkgs,
  ...
}:

let
  brave = lib.getExe config.programs.brave.finalPackage;

  hyprlandNested = pkgs.writeShellScriptBin "hyprland-nested" ''
    set -euo pipefail

    # Testa o Hyprland dentro da sessão GNOME/Wayland atual.
    # Usa a configuração Lua real gerada pelo Home Manager.
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland

    exec ${pkgs.hyprland}/bin/Hyprland --config "$HOME/.config/hypr/hyprland.lua"
  '';

  morningMessages = pkgs.writeShellScriptBin "morning-messages" ''
    set -euo pipefail

    exec ${brave} --new-window \
      "https://calendar.google.com/calendar/u/1/r/week" \
      "https://mail.google.com/mail/u/1/#inbox" \
      "https://web.whatsapp.com/" \
      "https://mail.google.com/mail/u/0/#inbox"
  '';

  llmDashboards = pkgs.writeShellScriptBin "llm-dashboards" ''
    set -euo pipefail

    exec ${brave} --new-window \
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
    ./hyprland-lua.nix
    ./rofi.nix
    ./quickshell.nix
  ];

  home = {
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      hyprcursor.enable = true;
      hyprcursor.size = 24;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    packages =
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
        morningMessages
        llmDashboards
        screenshotFull
        screenshotArea
      ];

    file = {
      ".config/zaney-stinger.mov".source = ../resources/zaney-stinger.mov;
      ".base16-themes".source = ../resources/base16-themes;
      ".face".source = ../resources/face.jpg;
      ".config/rofi/rofi.jpg".source = ../resources/rofi-gruvbox.jpg;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    # Configuração 100% em Lua (Hyprland 0.55+).
    # O conteúdo é injetado por ./hyprland-lua.nix via extraConfig.
    configType = "lua";
  };
}
