{
  pkgs,
  userSettings,
  ...
}:
let
  user = userSettings.name;
  dataDir = "/home/${user}/Zotero";
  profileDir = "/home/${user}/.zotero/zotero/hermes-server";
  enableLocalAPI = pkgs.writeShellScript "zotero-enable-local-api" ''
    set -eu
    printf '%s\n' \
      'user_pref("extensions.zotero.httpServer.enabled", true);' \
      'user_pref("extensions.zotero.httpServer.localAPI.enabled", true);' \
      > ${profileDir}/user.js
  '';
  checkLocalAPIPort = pkgs.writeShellScript "zotero-check-local-api-port" ''
    set -euo pipefail
    if ${pkgs.iproute2}/bin/ss -H -ltn 'sport = :23119' | ${pkgs.gnugrep}/bin/grep -q .; then
      echo "Port 127.0.0.1:23119 is already in use; refusing to start Zotero" >&2
      exit 1
    fi
  '';
  waitForLocalAPI = pkgs.writeShellScript "zotero-wait-for-local-api" ''
    set -eu
    for _ in $(${pkgs.coreutils}/bin/seq 1 45); do
      if ${pkgs.curl}/bin/curl --fail --silent --max-time 1 http://127.0.0.1:23119/api/ >/dev/null; then
        exit 0
      fi
      ${pkgs.coreutils}/bin/sleep 1
    done
    echo "Zotero started, but its Local API did not become ready on 127.0.0.1:23119" >&2
    exit 1
  '';
in
{
  # O banco SQLite e os anexos precisam permanecer em um diretório local do
  # host. O WebDAV do servidor continua sendo um backend separado para os
  # anexos, conforme a configuração em ./webdav.nix.
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0700 ${user} ${user} - -"
    "d /home/${user}/.zotero 0700 ${user} ${user} - -"
    "d /home/${user}/.zotero/zotero 0700 ${user} ${user} - -"
    "d ${profileDir} 0700 ${user} ${user} - -"
  ];

  # O Zotero não oferece atualmente um daemon headless oficial. Este serviço
  # executa o cliente normal em um display X virtual, sem expor uma sessão
  # gráfica ou uma porta X na rede. O perfil dedicado habilita o Local API,
  # disponível apenas em 127.0.0.1:23119.
  systemd.services.zotero = {
    description = "Zotero Desktop via Xvfb";
    documentation = [
      "https://www.zotero.org/support/dev/web_api/v3/local_api"
    ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    environment = {
      HOME = "/home/${user}";
    };

    serviceConfig = {
      Type = "simple";
      User = user;
      Group = user;
      WorkingDirectory = dataDir;
      ExecStartPre = [
        checkLocalAPIPort
        enableLocalAPI
      ];

      ExecStart =
        "${pkgs.xvfb-run}/bin/xvfb-run "
        + "-a "
        + "-s '-screen 0 1280x1024x24 -nolisten tcp' "
        + "${pkgs.zotero}/bin/zotero "
        + "-profile ${profileDir} "
        + "-datadir ${dataDir}";
      ExecStartPost = waitForLocalAPI;

      Restart = "always";
      RestartSec = 10;
      TimeoutStartSec = 120;
      KillMode = "control-group";
      UMask = "0077";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = false;
      ProtectSystem = "strict";
      ReadWritePaths = [
        dataDir
        profileDir
      ];
    };
  };
}
