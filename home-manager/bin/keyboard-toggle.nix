{ pkgs, ... }:
let
  keyboard-toggle-amr = pkgs.writeShellScriptBin "keyboard-toggle-amr" ''

    # Obter o layout atual executando o script (não apenas o comando)
    CURRENT_LAYOUT=$(${
      pkgs.writeShellScriptBin "keyboard-layout-status-amr" ""
    }/bin/keyboard-layout-status-amr)

    case "$CURRENT_LAYOUT" in
      "US")
        # Alternar para BR
        if command -v hyprctl >/dev/null; then
          hyprctl keyword input:kb_layout br
        elif command -v swaymsg >/dev/null; then
          swaymsg input type:keyboard xkb_layout br
        elif command -v setxkbmap >/dev/null; then
          setxkbmap br
        fi
        ;;
      "BR"|"ABNT2")
        # Alternar para US
        if command -v hyprctl >/dev/null; then
          hyprctl keyword input:kb_layout us
        elif command -v swaymsg >/dev/null; then
          swaymsg input type:keyboard xkb_layout us
        elif command -v setxkbmap >/dev/null; then
          setxkbmap us
        fi
        ;;
      *)
        # Default para US
        if command -v hyprctl >/dev/null; then
          hyprctl keyword input:kb_layout us
        elif command -v swaymsg >/dev/null; then
          swaymsg input type:keyboard xkb_layout us
        elif command -v setxkbmap >/dev/null; then
          setxkbmap us
        fi
        ;;
    esac

    # Notificar Waybar para atualizar
    pkill -SIGRTMIN+8 waybar
  '';
in { home.packages = [ keyboard-toggle-amr ]; }
