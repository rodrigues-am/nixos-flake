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
    ./postgresql.nix
    ./power.nix
    ../modules/syncthing.nix
    ./via.nix
    ./webdav.nix
  ];
}
