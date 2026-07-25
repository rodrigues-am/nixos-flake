{
  lib,
  pkgs,
  ...
}:
let
  viaDeps = pkgs.buildEnv {
    name = "aruba-via-runtime-dependencies";
    paths = map lib.getLib [
      pkgs.dbus
      pkgs.glib
      pkgs.gnutls
      pkgs.libcap
      pkgs.libproxy
      pkgs.libselinux
      pkgs.libxml2
      pkgs.networkmanager
      pkgs.nghttp2
      pkgs.systemd
      pkgs.tdb
      pkgs.util-linux
      pkgs.zlib
      pkgs.zstd
    ];
    pathsToLink = [ "/lib" ];
    ignoreCollisions = true;
  };
in
{
  boot.kernelModules = [ "tun" ];

  environment.systemPackages = [ pkgs.patchelf ];

  # O cliente é proprietário e permanece sob /opt. Este link fornece uma
  # árvore estável de bibliotecas da geração NixOS ativa para o RPATH do VIA.
  systemd.tmpfiles.rules = [
    "L+ /opt/aruba-via/deps - - - - ${viaDeps}"
    "L+ /usr/share/via - - - - /opt/aruba-via/share/via"
    "L+ /usr/bin/via-cli - - - - /opt/aruba-via/bin/via-cli"
    "L+ /usr/bin/via-vpn-srv - - - - /opt/aruba-via/bin/via-vpn-srv"
    "L+ /usr/bin/nm-viavpn-service - - - - /opt/aruba-via/bin/nm-viavpn-service"
    "L+ /usr/bin/via-login-handler - - - - /opt/aruba-via/bin/via-login-handler"
    "L+ /usr/bin/via-logout-handler - - - - /opt/aruba-via/bin/via-logout-handler"
    "L+ /usr/bin/via-reset-ui-handler - - - - /opt/aruba-via/bin/via-reset-ui-handler"
    "L+ /usr/bin/via-ui - - - - /opt/aruba-via/bin/via-ui"
  ];
}
