{ config, pkgs, lib, inputs, userSettings, home-manager, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit userSettings;
      inherit (inputs) nix-doom-emacs;
      inherit (inputs) nix-colors;
    };

    useUserPackages = true;
    useGlobalPkgs = true;
    users.${userSettings.name} = ./home.nix;

  };

}
