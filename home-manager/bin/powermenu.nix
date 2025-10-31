{ pkgs, ... }:

let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    #!/bin/sh
    set -euo pipefail

    # === CONFIGURAÇÕES ===
    UPTIME=$(uptime -p | sed 's/up //')
    HOST=$(hostname)
    LOCK_CMD="${pkgs.hyprlock}/bin/hyprlock"  # Use hyprlock (recomendado)
    # LOCK_CMD="${pkgs.swaylock-effects}/bin/swaylock -f --clock --indicator"  # Alternativa

    # === OPÇÕES COM ÍCONES ===
    shutdown=" Shutdown"
    reboot=" Restart"
    lock=" Lock"
    suspend=" Suspend"
    logout=" Logout"

    options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

    # === ROFI THEME (melhor UX) ===
    chosen="$(
      printf '%b' "$options" | \
      ${pkgs.rofi}/bin/rofi \
        -dmenu \
        -p "Uptime: $UPTIME" \
        -theme-str 'window { width: 360px; }' \
        -theme-str 'listview { lines: 5; }' \
        -theme-str 'element { padding: 12px; }' \
        -selected-row 2
    )"

    # === FUNÇÃO DE CONFIRMAÇÃO ===
    confirm() {
      printf 'yes\nno' | \
      ${pkgs.rofi}/bin/rofi \
        -dmenu \
        -p "Confirm $1?" \
        -theme-str 'window { width: 300px; }' \
        -selected-row 1 | grep -q '^yes'
    }

    # === AÇÃO ===
    case "$chosen" in
      "$shutdown")
        confirm "Shutdown" && systemctl poweroff
        ;;
      "$reboot")
        confirm "Restart" && systemctl reboot
        ;;
      "$lock")
        $LOCK_CMD
        ;;
      "$suspend")
        $LOCK_CMD & systemctl suspend
        ;;
      "$logout")
        # Tenta sair limpo
        if hyprctl dispatch exit > /tmp/hypr/logout.log 2>&1; then
          exit 0
        fi

        echo "[powermenu] hyprctl exit falhou. Tentando loginctl..." >> /tmp/hypr/logout.log

        # Força término da sessão
        loginctl terminate-session "$XDG_SESSION_ID" || loginctl terminate-user "$USER"

        # Fallback bruto (só se necessário)
        # sleep 2 && pkill -KILL -u "$USER" &
        ;;
    esac
  '';
in {
  home.packages = [ powermenu ];

  # Opcional: instale hyprlock
}
