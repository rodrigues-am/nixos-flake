{ config, pkgs, lib, ... }: {

  services.xremap = {
    withGnome = true;

    config.keymap = [{
      name = "Apps";
      remap = { alt-f = { launch = [ "${lib.getExe pkgs.firefox}" ]; }; };
    }];

  };
}
