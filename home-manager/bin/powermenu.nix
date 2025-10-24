{ pkgs, ... }:
let

  powermenu = pkgs.writeShellScriptBin "powermenu" ''

            # Options
            shutdown="Shutdown"
            reboot="Restart"
            lock="Lock"
            suspend="Suspend"
            logout="Logout"

            # Variable passed to rofi
            options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

            chosen="$(echo -e "$options" | ${pkgs.rofi}/bin/rofi -dmenu -selected-row 0)"
            case $chosen in
                $shutdown)
        # close all client windows
        # required for graceful exit since many apps aren't good SIGNAL citizens
        #HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
        #hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1

        systemctl poweroff
                    ;;
                $reboot)
        # close all client windows
        # required for graceful exit since many apps aren't good SIGNAL citizens
        #HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
        #hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1

         systemctl reboot
                    ;;
                $lock)
        swaylock
                    ;;
                $suspend)
         systemctl suspend
                    ;;
                $logout)
               # 1) tenta sair “limpo” do Hyprland
        if ! "$HYPRCTL" dispatch exit >>/tmp/hypr/logout.log 2>&1; then
          echo "[rofi-power] hyprctl falhou; tentando loginctl..." >>/tmp/hypr/logout.log
        fi

        # 2) se ainda estiver vivo após 1s, termina a sessão do usuário (volta ao greeter)
        sleep 1
        if pgrep -x hyprland >/dev/null; then
          loginctl terminate-user "$USER"
          # fallback final (bruto), se ainda assim nada:
          # pkill -KILL -u "$USER"
        fi
    ;;
            esac
  '';
in { home.packages = [ powermenu ]; }
