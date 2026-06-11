{
  config,
  pkgs,
  lib,
  ...
}:

let
  wpContainerHostAddress = "192.168.100.10";
  wpContainerAddress = "192.168.100.11";

  wpUrl = "http://${wpContainerAddress}";
in
{
  containers.wordpress-site = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = wpContainerHostAddress;
    localAddress = wpContainerAddress;

    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          curl
          wp-cli
          mariadb
        ];

        services.wordpress.sites."labdemo" = {
          virtualHost = {
            hostName = wpContainerAddress;

            extraConfig = lib.mkAfter ''
              ServerAlias ${wpContainerHostAddress}

              Alias /wp-content/ /var/lib/wordpress/labdemo/

              <Directory "/var/lib/wordpress/labdemo">
                Require all granted
                Options FollowSymLinks
                AllowOverride All
              </Directory>
            '';
          };

          database.createLocally = true;

          uploadsDir = "/var/lib/wordpress/labdemo/uploads";

          settings = {
            WPLANG = "pt_BR";
            FS_METHOD = "direct";

            WP_CONTENT_DIR = "/var/lib/wordpress/labdemo";
            WP_CONTENT_URL = "${wpUrl}/wp-content";

            WP_HOME = wpUrl;
            WP_SITEURL = wpUrl;

            FORCE_SSL_ADMIN = false;

            AUTOMATIC_UPDATER_DISABLED = true;
            WP_AUTO_UPDATE_CORE = false;
            DISALLOW_FILE_MODS = false;

            DISABLE_WP_CRON = false;
          };

          extraConfig = ''
            define('WP_TEMP_DIR', '/var/lib/wordpress/labdemo/tmp');
          '';
        };

        services.phpfpm.pools."wordpress-labdemo".phpOptions = ''
          upload_max_filesize = 64M
          post_max_size = 64M
          memory_limit = 256M
          max_execution_time = 300
          max_input_time = 300
        '';

        programs.nix-ld.enable = true;

        systemd.tmpfiles.rules = [
          "d /var/lib/wordpress/labdemo 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/uploads 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/plugins 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/themes 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/fonts 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/languages 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/tmp 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/upgrade 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/upgrade-temp-backup 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/upgrade-temp-backup/plugins 0770 wwwrun wwwrun - -"
          "d /var/lib/wordpress/labdemo/upgrade-temp-backup/themes 0770 wwwrun wwwrun - -"
        ];

        systemd.services.wordpress-labdemo-mutable-content-permissions = {
          wantedBy = [ "multi-user.target" ];

          after = [
            "wordpress-labdemo-permissions.service"
            "wordpress-init-labdemo.service"
          ];

          before = [
            "phpfpm-wordpress-labdemo.service"
            "httpd.service"
          ];

          serviceConfig.Type = "oneshot";

          script = ''
            mkdir -p /var/lib/wordpress/labdemo/{uploads,plugins,themes,fonts,languages,tmp,upgrade,upgrade-temp-backup/plugins,upgrade-temp-backup/themes}

            chown -R wwwrun:wwwrun /var/lib/wordpress/labdemo

            find /var/lib/wordpress/labdemo -type d -exec chmod 0770 {} \;
            find /var/lib/wordpress/labdemo -type f -exec chmod 0660 {} \;
          '';
        };

        systemd.services.wordpress-labdemo-cron = {
          description = "Run WordPress cron for labdemo";

          after = [
            "network-online.target"
            "httpd.service"
            "phpfpm-wordpress-labdemo.service"
          ];

          wants = [ "network-online.target" ];

          serviceConfig = {
            Type = "oneshot";
            User = "wwwrun";
            Group = "wwwrun";
          };

          path = with pkgs; [ curl ];

          script = ''
            curl \
              --silent \
              --show-error \
              --location \
              --max-time 60 \
              "${wpUrl}/wp-cron.php?doing_wp_cron" \
              >/dev/null
          '';
        };

        systemd.timers.wordpress-labdemo-cron = {
          description = "Run WordPress cron for labdemo every minute";

          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnBootSec = "2min";
            OnUnitActiveSec = "1min";
            AccuracySec = "15s";
            Unit = "wordpress-labdemo-cron.service";
          };
        };

        networking.firewall.allowedTCPPorts = [ 80 ];

        system.stateVersion = "26.05";
      };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = lib.mkForce "enp8s0";
  };

  # Sem abertura de portas no host.
  # O acesso fica restrito à rede privada host <-> container:
  #   http://192.168.100.11

  #services.nginx.enable = lib.mkForce false;
}
