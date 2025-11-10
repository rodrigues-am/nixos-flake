{ pkgs, ... }:

let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    # Menu simples de power baseado no padrão do emopicker
    chosen=$(
      printf " \tShutdown\n \tRestart\n \tLock\n \tSuspend\n \tLogout" | \
      ${pkgs.rofi}/bin/rofi -dmenu -p "Power Menu"
    )

    # Exit if none chosen
    [ -z "$chosen" ] && exit

    # Executar ação baseada na escolha
    case "$chosen" in
      " \tShutdown")
        systemctl poweroff
        ;;
      " \tRestart")
        systemctl reboot
        ;;
      " \tLock")
        ${pkgs.hyprlock}/bin/hyprlock
        ;;
      " \tSuspend")
        ${pkgs.hyprlock}/bin/hyprlock &
        systemctl suspend
        ;;
      " \tLogout")
        # Tentar sair do Hyprland primeiro
        if command -v hyprctl >/dev/null; then
          hyprctl dispatch exit
        else
          # Fallback para outras sessões
          loginctl terminate-session "''${XDG_SESSION_ID-}" || \
          pkill -KILL -u "$USER"
        fi
        ;;
    esac
  '';
in { home.packages = [ powermenu ]; }
