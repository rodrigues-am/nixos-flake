{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    # Zotero 10.0.4 falha após a troca do Firefox ESR; esta revisão fornece 10.0.2 validado.
    nixpkgs-zotero.url = "github:NixOS/nixpkgs/7a0f122f5090cf4c2ade2a13a0e229d4e19ba71f";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent/v2026.9.24";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    nix-doom-emacs.url = "github:librephoenix/nix-doom-emacs";

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      userSettings = rec {
        name = "andre";
        email = "rodrigues.am@usp.br";
        term = "alacritty";
        editor = "emacs";
        browser = "brave";
        locale = "pt_BR.UTF-8";
        gitUser = "rodrigues-am";
        wallpaperDir = "/home/andre/sync/pessoal/pic/wallpapers";
        theme = "gruvbox-dark-pale";
      };

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      pkgs-zotero = import inputs.nixpkgs-zotero {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      mkHost = machineName: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              machineName
              system
              userSettings
              pkgs-stable
              pkgs-zotero
              ;
            nixpkgs = { inherit pkgs; };
          };
          modules = [ module ];
        };

    in
    {

      nixosConfigurations = {
        hermes-server = mkHost "hermes-server" ./nixos/server;
        home-desktop = mkHost "home-desktop" ./nixos/home-desktop;
        hp-laptop = mkHost "hp-laptop" ./nixos/hp-laptop;
        thinkpad = mkHost "thinkpad" ./nixos/thinkpad;
      };
    };
}
