{
  pkgs,
  userSettings,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "timescaledb" ];
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = userSettings.locale;
  i18n.extraLocaleSettings = {
    LANGUAGE = "${userSettings.locale}:pt:en";
    LC_ADDRESS = userSettings.locale;
    LC_IDENTIFICATION = userSettings.locale;
    LC_MEASUREMENT = userSettings.locale;
    LC_MONETARY = userSettings.locale;
    LC_NAME = userSettings.locale;
    LC_NUMERIC = userSettings.locale;
    LC_PAPER = userSettings.locale;
    LC_TELEPHONE = userSettings.locale;
    LC_TIME = userSettings.locale;
  };

  users = {
    groups.${userSettings.name} = { };
    users.${userSettings.name} = {
      isNormalUser = true;
      description = userSettings.name;
      group = userSettings.name;
      extraGroups = [
        "networkmanager"
        "users"
        "wheel"
      ];
    };
  };

  programs.nix-ld.enable = true;

  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    age
    curl
    git
    jq
    python3
    ripgrep
    sops
  ];

  system.stateVersion = "26.05";
}
