{ config, pkgs, lib, ... }: {
  ervices.xremap = {
    withGnome = true;
    services.xremap.config.keymap = [{
      name = "Apps";
      remap = { C-return = [ "lauch" "Alacritty" ]; };
    }];
  };
}
