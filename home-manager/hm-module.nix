{
  config,
  pkgs,
  pkgs-stable,
  pkgs-zotero,
  lib,
  inputs,
  machineName,
  userSettings,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit machineName;
      inherit userSettings;
      inherit (inputs) nix-doom-emacs;
      inherit (inputs) nix-colors;
      inherit pkgs-stable;
      inherit pkgs-zotero;
    };

    useUserPackages = true;
    useGlobalPkgs = true;
    users.${userSettings.name} = ./home.nix;

    backupFileExtension = "bck";

  };

}
