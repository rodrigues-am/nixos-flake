#!/usr/bin/env bash
# Valida a configuração Lua do Hyprland gerada pelo Home Manager.
#
# Verifica:
#   1. Sintaxe Nix dos módulos (nix-instantiate --parse)
#   2. configType == "lua" (não deve haver fallback hyprlang)
#   3. Ausência de hyprland.conf gerado pelo Home Manager
#   4. Marcadores @...@ substituídos no Lua final
#   5. Padrões obsoletos ausentes
#   6. Trechos obrigatórios presentes
#   7. Atalhos literais sem duplicação
#   8. Sintaxe Lua válida (luac -p)
set -euo pipefail

host="${1:-home-desktop}"
user="${2:-andre}"
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp --suffix=-hyprland.lua)"
trap 'rm -f "$tmp"' EXIT

cd "$repo"

# 1. Sintaxe Nix dos módulos
nix-instantiate --parse home-manager/desktop/hyprland.nix >/dev/null
nix-instantiate --parse home-manager/desktop/hyprland-lua.nix >/dev/null

# 2. configType deve ser "lua"
config_type="$(nix eval --no-write-lock-file --raw \
  ".#nixosConfigurations.${host}.config.home-manager.users.${user}.wayland.windowManager.hyprland.configType" 2>/dev/null || true)"
if [[ "$config_type" != "lua" ]]; then
  echo "ERRO: configType deveria ser \"lua\", mas é \"${config_type:-<indefinido>}\"." >&2
  exit 1
fi

# 3. Não deve haver hyprland.conf gerado pelo Home Manager
conf_attr=".#nixosConfigurations.${host}.config.home-manager.users.${user}.xdg.configFile.\"hypr/hyprland.conf\".text"
if nix eval --no-write-lock-file --raw "$conf_attr" >/dev/null 2>&1; then
  echo "ERRO: Home Manager ainda gera hyprland.conf — o fallback hyprlang não foi removido." >&2
  exit 1
fi

# 4-7. Validação do conteúdo Lua gerado
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

# 8. Sintaxe Lua
if ! command -v luac >/dev/null 2>&1; then
  echo "ERRO: luac não está no PATH." >&2
  echo "Execute: nix shell nixpkgs#lua -c scripts/validate-hyprland-lua.sh '$host' '$user'" >&2
  exit 2
fi

luac -p "$tmp"
echo "lua-syntax-ok: $host / $user"
echo "config-type-ok: $config_type"