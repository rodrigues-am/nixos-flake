{ config, lib, pkgs, ... }:
let
  username = "andre";
  htpasswdFile = "/srv/webdav/.htpasswd";
in {
  services.nginx = {
    enable = true;
    package =
      pkgs.nginx.override { modules = with pkgs.nginxModules; [ dav ]; };
    virtualHosts."webdav.rodrigues-am.xyz" = {
      root = "/srv/webdav";
      locations."/".extraConfig = ''
        error_log /var/log/nginx/webdav-error.log;
        access_log /var/log/nginx/webdav-access.log;

        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        dav_access user:rw group:rw all:r;
        client_max_body_size 300M;
        autoindex on;
         disable_symlinks off;

        auth_basic "Restricted";
        auth_basic_user_file ${htpasswdFile};
      '';

      # Add!
      locations."/sync/" = {
        extraConfig = ''
          alias /home/andre/sync/; # O Nginx buscará os arquivos aqui

          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS;
          dav_access user:rw group:rw all:r;
          client_max_body_size 10G; # Ajustado se for sincronizar arquivos grandes
          autoindex on;
          disable_symlinks off;

          auth_basic "Restricted Sync";
          auth_basic_user_file ${htpasswdFile};
        '';
      };

      # Add!
      locations."/notas/" = {
        extraConfig = ''
          alias /home/andre/notas/; # O Nginx buscará os arquivos aqui

          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS;
          dav_access user:rw group:rw all:r;
          client_max_body_size 10G; # Ajustado se for sincronizar arquivos grandes
          autoindex on;
          disable_symlinks off;

          auth_basic "Restricted Sync";
          auth_basic_user_file ${htpasswdFile};
        '';
      };

    };
  };

  sops.secrets."webdav_key" = {
    owner = "root";
    mode = "0400";
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  systemd.paths.htpasswd-trigger = {
    description = "Dispara geração de htpasswd quando o segredo for carregado";
    pathConfig = { PathExists = "${config.sops.secrets.webdav_key.path}"; };
    wantedBy = [ "multi-user.target" ];
  };

  environment.etc."htpasswd-generate.sh" = {
    text = ''
      #!/bin/sh
      set -eu
      PASSWORD=$(cat /run/secrets/webdav_key)
      echo "[DEBUG] Senha lida: $PASSWORD" >> /home/andre/webdav-senha-usada.txt
      ${pkgs.apacheHttpd}/bin/htpasswd -bc ${htpasswdFile} ${username} "$PASSWORD"
      chown nginx:nginx ${htpasswdFile}
      chmod 640 ${htpasswdFile}
      echo "Pass: $PASSWORD  Dir: ${htpasswdFile}  Date: $(date)" >> /home/andre/webdav-senha-usada.txt
    '';
    mode = "0555"; # ← necessário para torná-lo executável!
  };

  systemd.services.htpasswd = {
    description = "Gera .htpasswd com base no segredo SOPS";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/etc/htpasswd-generate.sh";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/webdav 0755 nginx nginx - -"
    "d /srv/webdav/${username} 0755 nginx nginx - -"
    "d /srv/webdav/${username}/zotero 0755 nginx nginx - -"

    "d /home/${username}/sync 0775 ${username} nginx - -"
    "d /home/${username}/notas 0775 ${username} nginx - -"

    "L+ /srv/webdav/${username}/sync - - - - /home/${username}/sync"
    "L+ /srv/webdav/${username}/notas - - - - /home/${username}/notas"

    "d /var/log/nginx 0755 nginx nginx - -"

    # garante que nginx (no grupo andre) consiga atravessar /home/andre
    "z /home/${username} 0777 ${username} users - -"
    "z /home/${username}/sync 0777 ${username} nginx - -"
    "z /home/${username}/notas 0777 ${username} nginx - -"
  ];

  systemd.services.nginx.serviceConfig = {
    ProtectSystem = lib.mkForce "no";
    ProtectHome = lib.mkForce "no";
    ReadWritePaths = [ "/srv/webdav" "/home/andre/sync" "/home/andre/notas" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rodrigues.am83@gmail.com";
  };

  environment.systemPackages = with pkgs; [ cloudflared apacheHttpd ];

  systemd.user.services.cloudflared = {
    description = "Cloudflare Tunnel for WebDAV (User)";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.cloudflared}/bin/cloudflared tunnel run webdav-tunnel";
      Restart = "always";
      WorkingDirectory = "%h/.cloudflared";
      Environment = "DNS_OVER_HTTPS=off";
    };
  };

  users.users.nginx.extraGroups = [ "andre" ];

}
