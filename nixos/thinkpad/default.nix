{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/desktop.nix
    ./keymap-thinkpad.nix
    ../common/desktop-boot.nix

    inputs.home-manager.nixosModules.home-manager
    ../../home-manager/hm-module.nix
  ];
}
