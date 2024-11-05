{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    xremap-flake.url = "github:xremap/nix-flake";

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

    nix-doom-emacs.url = "github:librephoenix/nix-doom-emacs";

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nix-colors, sops-nix
    , hyprland, nix-doom-emacs, hyprland-plugins, ... }@inputs:
    let
      system = "x86_64-linux";

      userSettings = rec {
        name = "andre";
        email = "rodrigues.am@usp.br";
        term = "alacritty";
        editor = "emacsclient -c -a emacs";
        browser = "brave";
        locale = "pt_BR.UTF-8";
        gitUser = "rodrigues-am";
        wallpaperDir = "/home/andre/sync/pessoal/pic/wallpapers";
        theme = "gruvbox-dark-pale";
      };

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = { allowUnfree = true; };
      };

    in {
      nixosConfigurations = {

        ################
        # home-desktop #
        ################

        home-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit pkgs-stable;
            inherit pkgs;
          };

          modules = [

            ./nixos/home-desktop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/home-desktop/nvidia.nix
            ./nixos/home-desktop/game.nix
            ./nixos/desktop-keymap.nix
            ./nixos/boot-desktop.nix
            home-manager.nixosModules.home-manager
            { imports = [ ./home-manager/hm-module.nix ]; }
          ];
        };

        ###############
        # usp-desktop #
        ###############

        usp-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit pkgs-stable;
          };
          modules = [

            ./nixos/usp-desktop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/desktop-keymap.nix
            ./nixos/boot-desktop.nix

            home-manager.nixosModules.home-manager
            {
              imports = [ ./home-manager/hm-module.nix ];

            }

          ];
        };

        #############
        # hp-laptop #
        #############

        hp-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit pkgs-stable;
          };

          modules = [
            ./nixos/hp-laptop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/hp-laptop/keymap-hp-laptop.nix
            ./nixos/hp-laptop/boot-hp-laptop.nix

            home-manager.nixosModules.home-manager
            {

              imports = [ ./home-manager/hm-module.nix ];

            }

          ];
        };

        ################
        # dell-desktop #
        ################

        dell-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit pkgs-stable;
          };

          modules = [
            ./nixos/dell-laptop/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/dell-laptop/keymap-dell-laptop.nix
            ./nixos/dell-laptop/boot-dell-laptop.nix

            home-manager.nixosModules.home-manager
            { imports = [ ./home-manager/hm-module.nix ]; }

          ];
        };
        ################
        # thinkpad      #
        ################

        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit userSettings;
            inherit pkgs-stable;
          };

          modules = [
            ./nixos/thinkpad/hardware-configuration.nix
            ./nixos/core.nix
            ./nixos/thinkpad/keymap-thinkpad.nix
            ./nixos/boot-desktop.nix
            home-manager.nixosModules.home-manager
            { imports = [ ./home-manager/hm-module.nix ]; }

          ];
        };

      };
    };
}
