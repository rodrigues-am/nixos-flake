{ pkgs, ... }:
let
  keyboard-layout-status-amr =

    pkgs.writeShellScriptBin "keyboard-layout-status-amr" ''
             get_hyprland_layout() {
            hyprctl devices -j | jq -r '.keyboards[] | select(.name | test("(keyboard|at-translated-set)"; "i")) | .active_keymap' | head -1
          }

          get_sway_layout() {
            swaymsg -t get_inputs | jq -r '.[] | select(.type == "keyboard") | .xkb_active_layout_name' | head -1
          }

          get_x11_layout() {
            setxkbmap -query | grep layout | awk '{print $2}'
          }

          # Verificar qual ambiente está ativo, não apenas se o comando existe
          if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && command -v hyprctl >/dev/null; then
            LAYOUT=$(get_hyprland_layout)
          elif [ -n "$SWAYSOCK" ] && command -v swaymsg >/dev/null; then
            LAYOUT=$(get_sway_layout)
          elif command -v setxkbmap >/dev/null && [ -n "$DISPLAY" ]; then
            LAYOUT=$(get_x11_layout)
          else
            LAYOUT="unknown"
          fi

          # Debug: descomente a linha abaixo para ver o valor bruto
          # echo "DEBUG: Raw LAYOUT = '$LAYOUT'" >&2

         # Formatar saída - CASO CORRIGIDO
      case "$LAYOUT" in
        "English (US)"|"us"|"english"|"English (US, intl., with dead keys)")
          echo "us"
          ;;
        "Portuguese (Brazil)"|"br"|"portuguese"|"Portuguese")
          echo "br"
          ;;
        "abnt2")
          echo "abnt"
          ;;
        "us-intl")
          echo "us"
          ;;
        *)
          echo "''${LAYOUT:0:10}"
          ;;
      esac
    '';
in { home.packages = [ keyboard-layout-status-amr ]; }
