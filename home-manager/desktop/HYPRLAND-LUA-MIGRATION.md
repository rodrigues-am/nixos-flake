# Migração segura do Hyprland para Lua

## Objetivo

Migrar do `configType = "hyprlang"` para o formato Lua introduzido no Hyprland 0.55 sem tornar a sessão gráfica indisponível.

A migração é deliberadamente dividida em duas linhas Git:

- `main`: configuração Hyprlang conhecida e funcional, com as melhorias de monitor, NVIDIA, DPMS, blur, Dwindle e atalhos;
- `hyprland-lua-migration`: candidato Lua para validação antes de qualquer merge em `main`.

Nunca faça a primeira ativação do candidato Lua sem manter `main` e uma geração NixOS anterior disponíveis.

## Rede de segurança já declarada

A configuração comum dos desktops registra no GDM uma sessão adicional:

`Hyprland (safe fallback)`

Ela inicia o Hyprland com `~/.config/hypr/hyprland-nested.conf`, uma configuração mínima sem Quickshell, wallpaper ou outros serviços de sessão. O GNOME também permanece habilitado.

Portanto, depois da ativação haverá três caminhos de recuperação no GDM:

1. sessão Hyprland normal;
2. `Hyprland (safe fallback)`;
3. GNOME.

O atalho de terminal da sessão segura é `Super+Return`.

## Etapa 1 — validar a linha segura

Na máquina de destino:

```bash
git -C ~/nixos-flake switch main
git -C ~/nixos-flake pull --ff-only
sudo nixos-rebuild build --flake ~/nixos-flake#$(hostname)
```

Se o build terminar, prefira primeiro:

```bash
sudo nixos-rebuild test --flake ~/nixos-flake#$(hostname)
```

Antes de sair da sessão atual, confirme que a sessão segura aparece no seletor do GDM após reiniciar o display manager ou a máquina.

## Etapa 2 — testar o compositor mínimo aninhado

Entre no GNOME/Wayland e execute:

```bash
hyprland-nested-safe
```

Confirme:

- abre uma janela do Hyprland;
- `Super+Return` abre o terminal;
- `Super+Ctrl+Shift+C` encerra a sessão aninhada;
- teclado alterna entre US e BR com `Super+Space`;
- workspaces 1–10 funcionam.

## Etapa 3 — testar o candidato Lua sem alterar `main`

Faça esta etapa a partir de uma sessão **GNOME/Wayland**, não da sessão Hyprland normal. A ativação do Home Manager tenta recarregar instâncias Hyprland já abertas; executar o primeiro `test` dentro do Hyprland eliminaria parte da proteção oferecida pelo teste aninhado.

```bash
git -C ~/nixos-flake fetch origin
git -C ~/nixos-flake switch hyprland-lua-migration
sudo nixos-rebuild build --flake ~/nixos-flake#$(hostname)
```

Não use `switch` como primeiro teste. Após o build, use `test`:

```bash
sudo nixos-rebuild test --flake ~/nixos-flake#$(hostname)
```

Ainda dentro do GNOME, valide a configuração Lua gerada com o verificador versionado no repositório. O comando avalia o módulo do host, procura estruturas obsoletas ou marcadores não substituídos e executa `luac -p`:

```bash
nix shell nixpkgs#lua -c \
  scripts/validate-hyprland-lua.sh "$(hostname)" andre
```

Essa validação não ativa nenhuma geração. Se você já tiver `luac` no `PATH`, pode executar diretamente:

```bash
scripts/validate-hyprland-lua.sh "$(hostname)" andre
```

Em seguida, teste aninhado a partir do GNOME:

```bash
hyprland-nested
```

E verifique erros de configuração na sessão aninhada:

```bash
hyprctl configerrors
```

Somente prossiga se não houver erros e se terminal, Quickshell, wallpaper, teclado, screenshots e atalhos funcionarem.

## Etapa 4 — primeiro login real no candidato

1. mantenha o GNOME disponível;
2. encerre a sessão, sem reiniciar a máquina;
3. no GDM selecione o Hyprland normal;
4. se falhar, volte ao GDM e selecione `Hyprland (safe fallback)` ou GNOME;
5. a partir do terminal de recuperação, reverta para `main`.

```bash
git -C ~/nixos-flake switch main
sudo nixos-rebuild switch --rollback
```

Se o rollback não apontar para a geração desejada:

```bash
sudo nixos-rebuild switch --flake ~/nixos-flake#$(hostname)
```

## Etapa 5 — promover para `main`

Só faça merge depois de pelo menos um login completo e um ciclo de logout/login no candidato:

```bash
git -C ~/nixos-flake switch main
git -C ~/nixos-flake merge --ff-only hyprland-lua-migration
git -C ~/nixos-flake push origin main
```

## Critérios de aceite

- `hyprctl configerrors` vazio;
- monitor correto no desktop e modo automático nos laptops;
- Quickshell, wallpaper e agente Polkit iniciam uma única vez;
- `Super+Return` abre terminal;
- Telegram e janelas Brave vão aos workspaces 10, 2 e 8;
- Print e Shift+Print salvam em `~/Pictures/Screenshots`;
- atalhos de foco, movimento e resize funcionam;
- saída exige `Super+Ctrl+Shift+C`;
- compartilhamento de tela funciona no Brave;
- sessão segura e GNOME continuam acessíveis no GDM.
