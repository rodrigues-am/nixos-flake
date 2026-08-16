{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix

    inputs.sops-nix.nixosModules.sops
    inputs.hermes-agent.nixosModules.default

    ../common/base.nix
    ../common/network.nix
    ../common/sops.nix
    ./bash.nix
    ./hermes.nix
    ./hindsight.nix
    ./postgresql.nix
    ./power.nix
    ../modules/syncthing.nix
    ./via.nix
    ./webdav.nix
    ./zotero.nix
  ];

  # Este servidor tem 8 GiB de RAM e não possui partição swap. Atualizações
  # grandes chegaram a pressionar o systemd-journald e interromper a sessão.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Evita que quatro builds pesados concorram pela memória durante rebuilds.
  nix.settings.max-jobs = 2;
}
