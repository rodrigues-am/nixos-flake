{
  config,
  pkgs,
  lib,
  ...
}:

{
  containers.wordpress-site = {
    autoStart = true;
    # Configuração de rede local do container
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    config =
      { config, pkgs, ... }:
      {
        services.wordpress.sites."labdemo" = {
          virtualHost.hostName = "labdemo.rodrigues-am.xyz"; # Ou o IP público se não tiver domínio
          database.createLocally = true;
          uploadsDir = "/var/lib/wordpress/labdemo/uploads";
          settings = {
            WPLANG = "pt_BR";
            FS_METHOD = "direct";
            WP_CONTENT_DIR = "/var/lib/wordpress/labdemo";
          };
        };
        services.phpfpm.pools."wordpress-labdemo".phpOptions = ''
          upload_max_filesize = 64M
          post_max_size = 64M
          memory_limit = 256M
          max_execution_time = 300
          max_input_time = 300
        '';
        programs.nix-ld.enable = true;

        # O NixOS configura o Nginx automaticamente para o WordPress
        services.nginx.enable = true;
        users.users.nginx.extraGroups = [ "wwwrun" ];
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        system.stateVersion = "26.05"; # Use a versão do seu sistema
      };
  };

  # Redirecionamento de tráfego do Host para o Container
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = lib.mkForce "enp8s0";

    forwardPorts = [
      {
        sourcePort = 80;
        proto = "tcp";
        destination = "192.168.100.11:80"; # IP e Porta juntos aqui
      }
      {
        sourcePort = 443;
        proto = "tcp";
        destination = "192.168.100.11:443"; # IP e Porta juntos aqui
      }
    ];
  };
}
