{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/desktop.nix
    ./keymap-hp-laptop.nix
    ./boot-hp-laptop.nix

    inputs.home-manager.nixosModules.home-manager
    ../../home-manager/hm-module.nix
  ];
}
