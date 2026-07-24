{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  username = userSettings.name;
  authDir = "/var/lib/webdav-auth";
  htpasswdFile = "${authDir}/.htpasswd";
in
{
  services.nginx = {
    enable = true;
    package = pkgs.nginx.override {
      modules = with pkgs.nginxModules; [ dav ];
    };
    virtualHosts."webdav-tailnet" = {
      default = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 8080;
        }
      ];
      locations = {
        "/sync/".extraConfig = ''
          alias /home/${username}/sync/;
          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS;
          dav_access user:rw group:rw all:r;
          client_max_body_size 10G;
          auth_basic "WebDAV";
          auth_basic_user_file ${htpasswdFile};
        '';
        "/notas/".extraConfig = ''
          alias /home/${username}/notas/;
          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS;
          dav_access user:rw group:rw all:r;
          client_max_body_size 10G;
          auth_basic "WebDAV";
          auth_basic_user_file ${htpasswdFile};
        '';
      };
    };
  };

  systemd = {
    services = {
      webdav-htpasswd = {
        description = "Generate the WebDAV htpasswd file from a SOPS credential";
        wantedBy = [ "multi-user.target" ];
        before = [ "nginx.service" ];
        requiredBy = [ "nginx.service" ];
        serviceConfig = {
          Type = "oneshot";
          User = "nginx";
          Group = "nginx";
          StateDirectory = "webdav-auth";
          StateDirectoryMode = "0750";
          LoadCredential = "password:${config.sops.secrets.webdav_key.path}";
        };
        script = ''
          set -eu
          ${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/password" \
            | ${pkgs.apacheHttpd}/bin/htpasswd -ci ${lib.escapeShellArg htpasswdFile} ${lib.escapeShellArg username}
          ${pkgs.coreutils}/bin/chmod 0640 ${lib.escapeShellArg htpasswdFile}
        '';
      };

      nginx.serviceConfig = {
        ProtectHome = lib.mkForce false;
        ReadWritePaths = [
          "/home/${username}/sync"
          "/home/${username}/notas"
        ];
      };
    };

    tmpfiles.rules = [
      "d /home/${username}/sync 0775 ${username} users - -"
      "d /home/${username}/notas 0775 ${username} users - -"
      "a+ /home/${username} - - - - user:nginx:--x"
      "a+ /home/${username}/sync - - - - user:nginx:rwx,default:user:nginx:rwx"
      "a+ /home/${username}/notas - - - - user:nginx:rwx,default:user:nginx:rwx"
    ];
  };
}
