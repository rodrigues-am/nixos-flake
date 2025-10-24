{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "andre";
  };
  # services.immich = {
  #   enable = true;
  #   user = "andre";
  #   openFirewall = true;
  #   port = 2283;
  # };

  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
    config = {
      adminuser = "andre";
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "sqlite";
    };
  };
}
