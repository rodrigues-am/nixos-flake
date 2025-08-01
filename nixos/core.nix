{ config, lib, pkgs-stable, inputs, userSettings, nix-colors, pkgs, ... }:

{

  imports = [ # Include the results of the hardware scan.
    ./syncthing.nix
    ./polkit.nix
    ./emacs-overlay.nix
    ./isync-overlay.nix
    inputs.sops-nix.nixosModules.sops
    inputs.xremap-flake.nixosModules.default
    ./xremap.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [ "olm-3.2.16" ]; # para
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_13;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  programs.hyprland.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/.config/sops/age/keys.txt";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "${userSettings.locale}";

  i18n.extraLocaleSettings = {
    LANGUAGE = "${userSettings.locale}:pt:en";
    LC_ADDRESS = "${userSettings.locale}";
    LC_IDENTIFICATION = "${userSettings.locale}";
    LC_MEASUREMENT = "${userSettings.locale}";
    LC_MONETARY = "${userSettings.locale}";
    LC_NAME = "${userSettings.locale}";
    LC_NUMERIC = "${userSettings.locale}";
    LC_PAPER = "${userSettings.locale}";
    LC_TELEPHONE = "${userSettings.locale}";
    LC_TIME = "${userSettings.locale}";
    LC_ALL = "${userSettings.locale}";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.name} = {
    isNormalUser = true;
    description = "${userSettings.name}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  environment.variables = {
    POLKIT_BIN =
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [ home-manager ])
    ++ (with pkgs-stable; [ ]);

  # Enable the OpenSSH daemon.

  # services.postgresql.enable = true;

  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4010;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  xdg = {
    portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
      ];
    };
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  system.stateVersion = "24.11"; # Did you read the comment?
}
