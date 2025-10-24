{ pkgs, userSettings, ... }:
let

  wallsetter = pkgs.writeShellScriptBin "wallsetter" ''
    #!/usr/bin/env bash
    set -euo pipefail

    WALLDIR="${userSettings.wallpaperDir}"

    # pega *.jpg/jpeg/png/webp (recursivo)
    shopt -s nullglob globstar
    files=( "$WALLDIR"/**/*.jpg "$WALLDIR"/**/*.jpeg "$WALLDIR"/**/*.png "$WALLDIR"/**/*.webp )

    if [ "''${#files[@]}" -eq 0 ]; then
      echo "[wallsetter] Nenhuma imagem encontrada em $WALLDIR" >&2
      exit 1
    fi

    # garante que o daemon do swww está rodando
    if ! pgrep -x swww-daemon >/dev/null 2>&1; then
      ${pkgs.swww}/bin/swww-daemon &
      # dá um pequeno tempo pro daemon inicializar
      sleep 0.5
    fi

    # escolhe aleatoriamente uma imagem e define como wallpaper
    idx=$(${pkgs.coreutils}/bin/shuf -i 0-$(( ''${#files[@]}-1 )) -n 1)
    img="''${files[$idx]}"

    exec ${pkgs.swww}/bin/swww img "$img"
  '';
in { home.packages = [ wallsetter ]; }
