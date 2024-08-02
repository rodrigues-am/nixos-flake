{ config, lib, pkgs, ... }:

{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "thinkpad";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

}
