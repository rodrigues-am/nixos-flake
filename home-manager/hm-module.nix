{ config, pkgs, pkgs-stable, lib, inputs, userSettings, home-manager, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit userSettings;
      inherit (inputs) nix-doom-emacs;
      inherit (inputs) nix-colors;
      inherit pkgs-stable;
    };

    useUserPackages = true;
    useGlobalPkgs = true;
    users.${userSettings.name} = ./home.nix;

  };

}
