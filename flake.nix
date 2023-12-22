{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        home-desktop = nixpkgs.lib.nixosSystem {

          modules = [

            ./nixos/home-desktop/hardware-configuration.nix
            ./nixos/configuration.nix
            ./nixos/app/image.nix
            ./nixos/home-desktop/nvidia.nix
            ./nixos/home-desktop/game.nix
            ./nixos/desktop-keymap.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users.andre = ./home-manager/home.nix;

              };
            }

          ];
        };

        hp-laptop = nixpkgs.lib.nixosSystem {

          modules = [
            ./nixos/hp-laptop/hardware-configuration.nix
            ./nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users.andre = ./home-manager/home.nix;

              };
            }

          ];
        };

      };
    };
}
