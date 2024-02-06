{ config, lib, pkgs, ... }:

{
  services.xserver.xkb = {
    layout = "us";
    variant = "intl., with dead keys";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

}
