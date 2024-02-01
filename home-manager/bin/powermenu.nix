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

        chosen="$(echo -e "$options" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -selected-row 0)"
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
            #HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
            #hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
             hyprctl dispatch exit >> /tmp/hypr/hyprexitwithgrace.log 2>&1
                ;;
        esac
  '';
in { home.packages = [ powermenu ]; }
