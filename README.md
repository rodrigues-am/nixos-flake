# NixOS flake

Configuração declarativa das máquinas de André, com módulos NixOS e Home Manager compartilhados.

## Onde editar

| Objetivo | Arquivo ou diretório |
| --- | --- |
| Adicionar ou remover uma máquina | `flake.nix` |
| Escolher os módulos de uma máquina | `nixos/<maquina>/default.nix` |
| Hardware e boot específicos | `nixos/<maquina>/` |
| Base comum dos hosts gráficos | `nixos/common/desktop.nix` |
| Boot e teclado compartilhados pelos desktops | `nixos/common/desktop-boot.nix` e `desktop-keymap.nix` |
| Módulos NixOS reutilizáveis | `nixos/modules/` |
| Overlays NixOS | `nixos/modules/overlays/` |
| Serviços do `hermes-server` | `nixos/server/` |
| Serviços exclusivos do desktop principal | `nixos/home-desktop/` |
| Ponto de entrada do Home Manager | `home-manager/home.nix` |
| Programas do usuário | `home-manager/programs/` |
| Configuração da interface gráfica | `home-manager/desktop/` |
| Listas de pacotes | `home-manager/packages/` |
| Scripts instalados no perfil | `home-manager/scripts/` |
| Doom Emacs | `home-manager/emacs/` e `home-manager/programs/doom.nix` |
| Segredos declarados com SOPS | `secrets/secrets.yaml` e `.sops.yaml` |

## Organização

```text
.
├── flake.nix                    # inputs, dados do usuário e registro dos hosts
├── nixos/
│   ├── common/                  # bases compartilhadas de sistema e desktop
│   ├── modules/                 # módulos reutilizáveis, independentes de host
│   │   └── overlays/            # overlays do nixpkgs
│   ├── home-desktop/            # host home-desktop
│   ├── hp-laptop/               # host hp-laptop
│   ├── server/                  # host hermes-server
│   └── thinkpad/                # host thinkpad
├── home-manager/
│   ├── home.nix                 # ponto de entrada da configuração do usuário
│   ├── hm-module.nix            # integração Home Manager ↔ NixOS
│   ├── desktop/                 # ambiente gráfico e utilitários visuais
│   ├── programs/                # configuração individual de programas
│   ├── packages/                # listas de pacotes por finalidade
│   ├── scripts/                 # scripts empacotados como módulos Nix
│   ├── emacs/                   # arquivos da configuração Doom Emacs
│   └── resources/               # imagens e outros recursos estáticos
└── secrets/                     # arquivo SOPS criptografado
```

Cada host possui um `default.nix`. O `flake.nix` apenas registra o host; a lista de módulos fica junto dos demais arquivos daquela máquina. Para localizar um serviço, comece por:

```text
nixos/<nome-da-maquina>/default.nix
```

Hermes, Ollama e WebDAV rodam exclusivamente no `hermes-server`. As antigas variantes do `home-desktop` foram removidas; o histórico permanece disponível no Git.

## Convenções

- Um arquivo deve representar preferencialmente um serviço ou responsabilidade.
- Configuração exclusiva de hardware fica no diretório do host.
- Configuração reutilizável fica em `nixos/modules/`.
- Bases compostas compartilhadas entre hosts ficam em `nixos/common/`.
- Módulos desativados não são mantidos comentados: o histórico do Git é a referência.
- `config.org` é a fonte literária da configuração do Emacs; `config.el` deve permanecer sincronizado para uso antes do próximo tangle.
- Saídas de build (`result`) e arquivos temporários do editor não pertencem ao Git.
- Os comandos de avaliação, teste e switch devem ser executados de forma consciente e na ordem apropriada.

## Ciclo de implantação por máquina

Execute na raiz do repositório, substituindo `<host>` pelo nome da máquina:

```bash
# 1. Avaliação rápida
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath

# 2. Build sem ativação
nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel

# 3. Ativação temporária para teste
sudo nixos-rebuild test --flake .#<host>

# 4. Persistência após validar a máquina
sudo nixos-rebuild switch --flake .#<host>
```

Hosts registrados: `home-desktop`, `hp-laptop`, `thinkpad` e `hermes-server`.
