{ config, lib, pkgs, ... }:

{
  services.xserver = {
    layout = "us";
    xkbVariant = "intl., with dead keys";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

}
