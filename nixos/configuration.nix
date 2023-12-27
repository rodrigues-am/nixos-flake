# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

let

  user = "andre";

in {
  imports = [ # Include the results of the hardware scan.
    #./hardware-configuration.nix
    #./nvidia.nix
    ./syncthing.nix
    inputs.sops-nix.nixosModules.sops
    #./hyprland.nix
    #./game.nix

  ];

  programs.hyprland.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "~/sync/pessoal/security/sops-keys.txt";

    #secrets.hello = { };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  #networking = {
  #     networkmanager.enable = true;
  #     hostName = "nixos";
  #     nameservers = [ "1.1.1.1" "::1"];
  #     dhcpcd.extraConfig = "nohook resolv.conf";
  #     networkmanager.dns = lib.mkDefault "none";
  #     resolvconf.dnsExtensionMechanism = false;
  #   };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LANGUAGE = "pt_BR:pt:en";
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andre = {
    isNormalUser = true;
    description = "andre";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      #  thunderbird

      # database
      sqlite
      #surrealdb
      postgresql

      # general
      #postman

      # common-lisp
      sbcl
      rlwrap

      # python
      python3Full

      # r
      R
      rstudio

      # rust
      rustc
      rustup
      rustfmt
      rust-analyzer
      cargo

      #nodejs
      nodejs_21
      nodePackages.grammarly-languageserver

      #Web
      html-tidy
      stylelint
      nodePackages.js-beautify

      #Nix
      nixfmt

      #Yaml
      yaml-language-server
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    aspell
    aspellDicts.pt_BR
    aspellDicts.en
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US-large

    alacritty
    age
    auctex
    bat
    brave
    calibre
    cmake
    curl
    dmenu
    dunst
    element-desktop
    espanso
    espanso-wayland
    eza
    fd
    feh
    firefox
    fzf
    gh
    git
    gnome.gucharmap
    gnucash
    gnumake
    gnupg
    gnuplot
    graphviz
    home-manager
    htop
    hugo
    hyprland
    jq # A lightweight and flexible command-line JSON processor
    leftwm
    libreoffice
    libsForQt5.okular
    maim # A command-line screenshot utility to emacs
    mpv
    neofetch
    neovim
    nyxt
    pandoc
    pass
    pdftk
    picom
    plantuml
    polybarFull
    ranger
    ripgrep
    rofi
    rofi-wayland
    shellcheck
    shfmt
    starship
    stow
    swww
    sops
    sxhkd
    syncthing
    texlive.combined.scheme-full
    waybar
    wget
    xclip
    xdg-desktop-portal-hyprland
    xournal
    zathura
    zoom
    zotero

    # fonts
    dejavu_fonts
    emacs-all-the-icons-fonts
    comic-relief
    font-awesome_4
    fira-code
    google-fonts

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # programs.gnupg.agent = {
  #    enable = true;
  #    enableSSHSupport = true;
  #  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #  services.openssh = {
  #   enable = true;
  # passwordauthentication = false;
  #  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443];
  #   networking.firewall.allowedUDPPorts = [{from=4000; to=4007;} {from=8000; to=8010;} ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = true;

  services.postgresql.enable = true;

  services.espanso.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
