{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        home-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [

            ./nixos/home-desktop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/app/image.nix
            ./nixos/home-desktop/nvidia.nix
            ./nixos/home-desktop/game.nix
            ./nixos/desktop-keymap.nix
            ./nixos/boot-desktop.nix

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
        usp-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [

            ./nixos/usp-desktop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/desktop-keymap.nix
            ./nixos/boot-desktop.nix

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
          specialArgs = { inherit inputs; };

          modules = [
            ./nixos/hp-laptop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/hp-laptop/keymap-hp-laptop.nix
            ./nixos/hp-laptop/boot-hp-laptop.nix

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
