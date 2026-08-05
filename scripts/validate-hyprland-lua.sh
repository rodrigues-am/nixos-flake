#!/usr/bin/env bash
set -euo pipefail

host="${1:-home-desktop}"
user="${2:-andre}"
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp --suffix=-hyprland.lua)"
trap 'rm -f "$tmp"' EXIT

cd "$repo"

nix-instantiate --parse home-manager/desktop/hyprland.nix >/dev/null
nix-instantiate --parse home-manager/desktop/hyprland-lua.nix >/dev/null

attr=".#nixosConfigurations.${host}.config.home-manager.users.${user}.xdg.configFile.\"hypr/hyprland.lua\".text"
nix eval --no-write-lock-file --raw "$attr" > "$tmp"

python3 - "$tmp" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text()

bad_patterns = {
    r"hl\.(?:binde|exec-once|general|input|misc|decoration|dwindle)\b": "chamada Lua gerada a partir de chave Hyprlang antiga",
    r"bind\s*=\s*=": "atribuição de bind malformada",
    r"WLR_NO_HARDWARE_CURSORS": "variável wlroots obsoleta",
    r"@(?:terminal|browser|editor|isNvidia|monitorOutput|monitorMode|monitorPosition|monitorScale|homeDir|activeBorderA|activeBorderB|inactiveBorderA|inactiveBorderB|polkitAgent|wallpaper)@": "marcador Nix não substituído",
}

errors = []
for pattern, description in bad_patterns.items():
    if re.search(pattern, text):
        errors.append(description)

required = [
    'hl.monitor(',
    'hl.config(',
    'hl.on("hyprland.start"',
    'hl.bind("SUPER + RETURN"',
    'hl.bind("Print"',
    'workspace = "10"',
    'workspace = "2"',
    'workspace = "8"',
]
for anchor in required:
    if anchor not in text:
        errors.append(f"trecho obrigatório ausente: {anchor}")

literal_binds = re.findall(r'hl\.bind\("([^"]+)"', text)
normalized = {}
for binding in literal_binds:
    key = " + ".join(sorted(part.strip().upper() for part in binding.split("+")))
    if key in normalized:
        errors.append(f"atalho literal duplicado: {binding} / {normalized[key]}")
    normalized[key] = binding

if errors:
    for error in errors:
        print(f"ERRO: {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"estrutura-gerada-ok: {len(text)} bytes, {len(literal_binds)} binds literais")
PY

if ! command -v luac >/dev/null 2>&1; then
  echo "ERRO: luac não está no PATH." >&2
  echo "Execute: nix shell nixpkgs#lua -c scripts/validate-hyprland-lua.sh '$host' '$user'" >&2
  exit 2
fi

luac -p "$tmp"
echo "lua-syntax-ok: $host / $user"
