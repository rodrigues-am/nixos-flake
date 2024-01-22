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

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    nix-doom-emacs.url = "github:librephoenix/nix-doom-emacs?ref=pgtk-patch";
    eaf = {
      url = "github:emacs-eaf/emacs-application-framework";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager,  ... }@inputs:
    let
      system = "x86_64-linux";

      userSettings = rec {
        name = "andre";
        email = "rodrigues.am@usp.br";
        term = "alcritty";
        editor = "emacs";
        locale = "pt_BR.UTF-8";
        gitUser = "rodrigues-am";
      };

      pkgs = nixpkgs.legacyPackages.${system};

    in {
      nixosConfigurations = {

        # home-desktop
        home-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs;
                          inherit userSettings;
                        };

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
                extraSpecialArgs = {
                  inherit inputs;
                  inherit userSettings;
                  inherit (inputs) nix-doom-emacs;
                };
                useUserPackages = true;
                useGlobalPkgs = true;
                users.${userSettings.name} = ./home-manager/home.nix;

              };
            }

          ];
        };

        # usp-desktop
        usp-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs;
                          inherit userSettings;
                        }
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
                users.${userSettings.name} = ./home-manager/home.nix;

              };
            }

          ];
        };

        # hp-laptop
        hp-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit userSettings; };

          modules = [
            ./nixos/hp-laptop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/hp-laptop/keymap-hp-laptop.nix
            ./nixos/hp-laptop/boot-hp-laptop.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; inherit userSettings; };
                useUserPackages = true;
                useGlobalPkgs = true;
                users.${userSettings.name} = ./home-manager/home.nix;

              };
            }

          ];
        };

        # dell-laptop
        dell-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; inherit userSettings; };

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
                users.${userSettings.name} = ./home-manager/home.nix;

              };
            }

          ];
        };

      };
    };
}
