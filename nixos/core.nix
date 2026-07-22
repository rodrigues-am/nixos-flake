{
  pkgs-stable,
  config,
  inputs,
  userSettings,
  pkgs,
  ...
}:

{
  imports = [
    ./syncthing.nix
    ./polkit.nix
    ./emacs-overlay.nix
    ./isync-overlay.nix
    ./print.nix
    ./mcp.nix
    ./sops-env.nix
    ./fonts.nix
    inputs.sops-nix.nixosModules.sops
    # inputs.xremap-flake.nixosModules.default
    # ./xremap.nix
  ];
  services.flatpak.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      python313Packages = prev.python313Packages.overrideScope (
        pyFinal: pyPrev: {
          proton-core = pyPrev.proton-core.overridePythonAttrs (oldAttrs: {
            doCheck = false;
          });
        }
      );
    })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
    "openssl-1.1.1w"
    "xpdf-4.05"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  programs.nix-ld.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

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

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${userSettings.name} = {
    isNormalUser = true;
    description = "${userSettings.name}";

    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
    ];

    packages = with pkgs; [
      proton-vpn
    ];
  };

  environment.systemPackages =
    (with pkgs; [
      home-manager
    ])
    ++ (with pkgs-stable; [
    ]);

  services.openssh.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;

    # Permite que tráfego vindo da Tailnet acesse serviços locais,
    # incluindo o Nginx do host em http://100.80.86.16.
    trustedInterfaces = [
      config.services.tailscale.interfaceName
    ];

    # Porta UDP usada pelo Tailscale.
    allowedUDPPorts = [
      config.services.tailscale.port
    ];

    # Não abrimos 80/443 globalmente aqui.
    # O acesso ao WordPress deve vir pela interface Tailscale,
    # que já está em trustedInterfaces.
    allowedTCPPorts = [ ];

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

    checkReversePath = "loose";
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };

      gnome = {
        default = [
          "gnome"
          "gtk"
        ];
      };

      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
    };
  };

  system.stateVersion = "26.05";
}
