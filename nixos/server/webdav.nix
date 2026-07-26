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
  zoteroDataDir = "/srv/webdav/${username}/zotero";
in
{
  users.users.nginx.extraGroups = [ "users" ];

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
        "/andre/zotero/".extraConfig = ''
          alias ${zoteroDataDir}/;
          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS;
          dav_access user:rw group:rw all:r;
          create_full_put_path on;
          client_max_body_size 10G;
          autoindex off;
          auth_basic "Zotero WebDAV";
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
        ReadWritePaths = [ zoteroDataDir ];
      };
    };

    tmpfiles.rules = [
      "d /srv/webdav 0750 root users - -"
      "d /srv/webdav/${username} 0750 ${username} users - -"
      "d ${zoteroDataDir} 2770 ${username} users - -"
    ];
  };
}
