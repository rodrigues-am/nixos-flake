{ lib, stdenv, dpkg, tdb, xdg-utils, patchelf, qt5, zlib, libxml2, libproxy
, dbus, networkmanager, glib }:

stdenv.mkDerivation rec {
  pname = "via-vpn";
  version = "4.7.0";

  src = ./via_4.7.0.2404092-deb_amd64.deb;

  nativeBuildInputs = [ dpkg patchelf xdg-utils qt5.wrapQtAppsHook ];
  buildInputs =
    [ zlib libxml2 libproxy qt5.qtbase dbus.lib tdb networkmanager glib ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
               mkdir -p $out/bin
        mkdir -p $out/lib

        # Bibliotecas proprietárias do .deb
        cp usr/lib/libancrypto.so $out/lib/
        cp usr/lib/libantputils.so $out/lib/
        cp usr/lib/libanmocana.so $out/lib/   # <- nova

        # Corrige e empacota os binários
        for bin in via-ui via-vpn-srv via-cli via-login-handler via-logout-handler; do
          cp usr/bin/$bin $out/bin/
          patchelf \
            --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
            --force-rpath \
            --set-rpath "$out/lib:${lib.makeLibraryPath buildInputs}" \
            $out/bin/$bin
        done

        ln -s $out/bin/via-ui $out/bin/via

    mkdir -p $out/var/lib/via-vpn/logs
    mkdir -p $out/usr/share/via
    ln -s $out/var/lib/via-vpn/logs $out/usr/share/via/logs

            makeWrapper $out/bin/via-ui $out/bin/via \
              --set-default ELECTRON_TRASH "/bin/true" \
              --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    description = "VIA VPN Client";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
