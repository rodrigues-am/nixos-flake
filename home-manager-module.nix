{ config, lib, pkgs, ... }:

{
  home-manager.nixosModules.home-manager {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users.andre = ./home-manager/home.nix;

              };
            }
}
