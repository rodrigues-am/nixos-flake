{ config, pkgs, lib, ... }:

let
  # Caminho relativo: de nixos/ até home-manager/via-vpn/tmp
  viaExtracted = builtins.path {
    path = ../../home-manager/via-vpn/tmp;
    name = "aruba-via-extracted";
  };

  # Cria binários no PATH
  viaBin = pkgs.writeShellScriptBin "via" ''
    exec /opt/aruba/via/bin/via "$@"
  '';

  viaUiBin = pkgs.writeShellScriptBin "via-ui" ''
    exec /opt/aruba/via/usr/bin/via-ui "$@"
  '';
in {
  # Firewall
  networking.firewall.allowedUDPPorts = [ 500 4500 ];
  networking.firewall.allowPing = true;

  # Script de ativação (só copia arquivos)
  system.activationScripts.via-install = lib.stringAfter [ "users" ] ''
    if [ ! -x /opt/aruba/via/bin/via ]; then
      echo "Instalando Aruba VIA de ${viaExtracted}..."
      mkdir -p /opt/aruba/via
      cp -r ${viaExtracted}/* /opt/aruba/via/ || {
        echo "ERRO: Falha ao copiar. Verifique se home-manager/via-vpn/tmp/ existe."
        exit 1
      }
      chmod -R 755 /opt/aruba/via
      chmod +x /opt/aruba/via/bin/via /opt/aruba/via/usr/bin/* 2>/dev/null || true
      echo "Aruba VIA instalado em /opt/aruba/via"
    fi
  '';
  # Adiciona binários ao PATH (agora fora da string!)
  environment.systemPackages = [ viaBin viaUiBin ];

  # Serviço systemd (opcional)
  systemd.services.aruba-via = {
    description = "Aruba VIA VPN Client Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "/opt/aruba/via/bin/via --daemon";
      ExecStop = "/opt/aruba/via/bin/via --stop";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # StrongSwan
  services.strongswan.enable = true;
  services.strongswan.enabledPlugins =
    [ "attr-sql" "eap-mschapv2" "kernel-libipsec" ];
}
