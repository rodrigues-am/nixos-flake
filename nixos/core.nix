{ config, lib, pkgs, inputs, userSettings, nix-colors, ... }:

let

in {
  imports = [ # Include the results of the hardware scan.
    ./syncthing.nix
    inputs.sops-nix.nixosModules.sops
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
    age.keyFile = ".config/sops/age/keys.txt";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.name} = {
    isNormalUser = true;
    description = "andre";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #firefox
      #  thunderbird

      # database
      sqlite
      #surrealdb
      #postgresql

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

    alacritty # terminal
    age # encryption
    auctex # text
    bat
    brave # web browser
    calibre
    cmake
    curl
    #dmenu
    #dunst
    element-desktop
    espanso
    espanso-wayland
    eza
    fd
    #feh
    firefox # web browser
    fzf
    gh
    git
    gnome.gucharmap
    gnucash
    gnumake
    gnupg
    gnuplot
    graphviz # build diagrams declaratively
    home-manager
    htop
    hugo # blog and static sities
    #hyprland
    jq # lightweight and flexible command-line JSON processor
    #leftwm
    libreoffice
    maim # command-line screenshot utility to emacs
    mpv # media player
    neofetch
    neovim
    nyxt # web browser
    pandoc
    pass
    pdftk
    #picom
    plantuml # build diagrams declaratively
    #polybarFull
    ranger # file manager
    ripgrep
    #rofi
    #rofi-wayland
    shellcheck
    shfmt
    starship # terminal prompt
    stow
    swww
    sops
    syncthing
    texlive.combined.scheme-full # latex
    unzip
    #waybar
    wget
    xclip
    #xdg-desktop-portal-hyprland
    xournal # pdf edit
    zathura # pdf viwer
    zip
    zoom
    zotero

    # fonts
    dejavu_fonts
    emacs-all-the-icons-fonts
    font-awesome_4
    fira-code
    comic-relief
    google-fonts

  ];

  # Enable the OpenSSH daemon.

  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      {
        from = 4000;
        to = 4007;
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

  #services.postgresql.enable = true;
  # services.espanso.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
