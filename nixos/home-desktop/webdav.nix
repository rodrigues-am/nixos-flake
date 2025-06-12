{ config, lib, pkgs, ... }:
let
  username = "andre";
  password = "${config.sops.secrets.webdav_key.path}";
  htpasswdFile = "/srv/webdav/.htpasswd";
in {
  services.nginx = {
    enable = true;
    package =
      pkgs.nginx.override { modules = with pkgs.nginxModules; [ dav ]; };
    virtualHosts."webdav.rodrigues-am.xyz" = {
      enableSSL = false;
      root = "/srv/webdav";
      locations."/".extraConfig = ''
        error_log /var/log/nginx/webdav-error.log;
        access_log /var/log/nginx/webdav-access.log;

        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        dav_access user:rw group:rw all:r;
        client_max_body_size 300M;
        autoindex on;

        auth_basic "Restricted";
        auth_basic_user_file ${htpasswdFile};
      '';
    };
  };

    # Cria .htpasswd no destino final
  system.activationScripts.htpasswd = ''

 HTPASSWD="${pkgs.apacheHttpd}/bin/htpasswd"
  mkdir -p $(dirname ${htpasswdFile})
  $HTPASSWD -bc ${htpasswdFile} "${username}" "$(cat ${config.sops.secrets.webdav_key.path})"
  chown nginx:nginx ${htpasswdFile}
  chmod 640 ${htpasswdFile}
'';

  systemd.tmpfiles.rules = [
    "d /srv/webdav/${username}/zotero 0755 nginx nginx - -"
    "d /var/log/nginx 0755 nginx nginx - -"
  ];

  systemd.services.nginx.serviceConfig = {
    ProtectSystem = lib.mkForce "no";
    ReadWritePaths = [ "/srv/webdav" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rodrigues.am83@gmail.com";
  };

  environment.systemPackages = with pkgs; [ cloudflared apacheHttpd ];

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel for WebDAV";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel run webdav-tunnel";
      Restart = "always";
      User = "root";
      WorkingDirectory = "/root/.cloudflared";
    };
  };

}
