{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/desktop.nix
    ./nvidia.nix
    ./game.nix
    ./hermes-desktop.nix
    ../common/desktop-keymap.nix
    ../common/desktop-boot.nix
    ./labdemo.nix

    inputs.home-manager.nixosModules.home-manager
    ../../home-manager/hm-module.nix
  ];
}
