# Configuração do Hyprland em Lua

## Estado atual

A configuração do Hyprland é 100% em Lua (Hyprland 0.55+). Não há fallback
hyprlang e não há sessão de recuperação separada.

## Arquitetura

- `home-manager/desktop/hyprland.nix` — módulo-base: pacotes, scripts,
  `wayland.windowManager.hyprland` com `configType = "lua"`.
- `home-manager/desktop/hyprland-lua.nix` — injeta o template Lua via
  `extraConfig`, substituindo marcadores `@...@` pelos valores calculados
  a partir de `machineName`, `userSettings` e `config.colorScheme`.
- `home-manager/desktop/hyprland-lua.lua` — template Lua canônico com
  monitor, env, config, curves, animations, binds e autostart.

## Validação

Antes de fazer push, valide a configuração gerada:

```bash
nix shell nixpkgs#lua -c \
  scripts/validate-hyprland-lua.sh "$(hostname)" andre
```

O validador verifica:
- sintaxe Nix dos módulos;
- `configType == "lua"`;
- ausência de `hyprland.conf` gerado pelo Home Manager;
- marcadores `@...@` substituídos;
- padrões obsoletos ausentes;
- trechos obrigatórios presentes;
- atalhos literais sem duplicação;
- sintaxe Lua válida (`luac -p`).

## Teste aninhado

Para testar o Hyprland dentro de uma sessão GNOME/Wayland sem reiniciar:

```bash
hyprland-nested
```

Este script abre o Hyprland com a configuração Lua real gerada pelo Home
Manager. Verifique erros com:

```bash
hyprctl configerrors
```

## Recuperação

Se a sessão Hyprland não iniciar:
- o GNOME permanece disponível no GDM como sessão alternativa;
- a partir do GNOME, use `hyprland-nested` para testar a configuração;
- reverta o commit problemático e faça `pull` na máquina.