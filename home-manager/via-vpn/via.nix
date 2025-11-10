{ pkgs, stdenv, stdenvNoCC, lib, dpkg, makeWrapper, patchelf, glib, gtk3
, libsecret, openssl_1_1, zlib, libpcap, libcap, networkmanager, dbus, xorg
, libxml2, tdb, libproxy, qt5, opensc
, srcDeb ? ./via_4.7.0.2404092-deb_amd64.deb }:

let gsettingsSchemas = pkgs.gsettings-desktop-schemas;
in stdenvNoCC.mkDerivation rec {
  pname = "aruba-via-local";
  version = "1.0";

  src = srcDeb;

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ dpkg makeWrapper patchelf ];

  buildInputs = [
    glib
    gtk3
    gsettingsSchemas
    libsecret
    openssl_1_1
    zlib
    libpcap
    libcap
    networkmanager
    dbus
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    libxml2
    tdb
    libproxy
    qt5.qtbase
    qt5.qtwayland
    opensc
  ];

  installPhase = ''
    runHook preInstall
    echo "Desempacotando .deb em $out"
    mkdir -p "$out"
    ${dpkg}/bin/dpkg -x "$src" "$out"

    # Remover arquivos problemáticos
    rm -f "$out/usr/share/via/opensc-pkcs11.so" 2>/dev/null || true
    rm -f "$out/usr/share/via/pkcs11-engine.so" 2>/dev/null || true

    if [ -d "$out/usr/bin" ]; then
      chmod +x "$out/usr/bin/"* 2>/dev/null || true
    fi

    if [ -f "$out/etc/bash_completion.d/via-cli" ]; then
      mkdir -p "$out/share/bash-completion/completions"
      cp -a "$out/etc/bash_completion.d/via-cli" \
        "$out/share/bash-completion/completions/via-cli"
    fi

    rm -rf "$out/etc/init.d" "$out/etc/dbus-1.system.d" 2>/dev/null || true
    mkdir -p "$out/bin"

    runHook postInstall
  '';

  postFixup = ''
    # Primeiro, mate quaisquer processos via que possam estar rodando
    pkill -f "via-cli" || true
    pkill -f "aruba-via" || true
    sleep 1

    # Library path com todas as dependências
    libPath="${lib.makeLibraryPath buildInputs}:$out/usr/lib"

    # Aplicar patchelf nos binários ELF ORIGINAIS (não nos wrappers)
    echo "Aplicando patchelf nos binários ELF..."
    for bin in via-ui via-cli via-vpn-srv nm-viavpn-service; do
      if [ -f "$out/usr/bin/$bin" ]; then
        # Verificar se é um binário ELF (não script)
        if file "$out/usr/bin/$bin" | grep -q "ELF"; then
          echo "Patchando binário ELF: $bin"
          # Definir o interpreter (linker dinâmico do Nix)
          patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" "$out/usr/bin/$bin"
          # Definir RPATH para encontrar as bibliotecas
          patchelf --set-rpath "$libPath" "$out/usr/bin/$bin"
          # Copiar para $out/bin
          cp -a "$out/usr/bin/$bin" "$out/bin/$bin"
        else
          echo "$bin não é um binário ELF, é um script"
          # Se for script, copiar diretamente
          cp -a "$out/usr/bin/$bin" "$out/bin/$bin"
        fi
      fi
    done

    # Aplicar patchelf nas bibliotecas internas
    find "$out/usr/lib" -name "*.so" -type f -exec \
      patchelf --set-rpath "$libPath" {} \; 2>/dev/null || true

    # VERIFICAR: Agora criar wrappers SIMPLES que chamam os binários patchados
    # Não usar makeWrapper com bash, mas sim chamar o binário diretamente

    # Para via-ui (Qt)
    makeWrapper "$out/bin/via-ui" "$out/bin/aruba-via-ui" \
      --prefix QT_PLUGIN_PATH : "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${qt5.qtbase}/${qt5.qtbase.qtQmlPrefix}" \
      --prefix XDG_DATA_DIRS : "$out/share:${gtk3.out}/share:${gsettingsSchemas}/share" \
      --prefix GSETTINGS_SCHEMA_DIR : "${gsettingsSchemas}/share/glib-2.0/schemas" \
      --prefix GIO_EXTRA_MODULES : "${glib.out}/lib/gio/modules" \
      --prefix LD_LIBRARY_PATH : "$libPath"

    # Para via-cli - wrapper SIMPLES
    makeWrapper "$out/bin/via-cli" "$out/bin/aruba-via-cli" \
      --prefix LD_LIBRARY_PATH : "$libPath"

    # Para via-vpn-srv
    makeWrapper "$out/bin/via-vpn-srv" "$out/bin/aruba-via-vpn-srv" \
      --prefix LD_LIBRARY_PATH : "$libPath"

    # Para nm-viavpn-service
    makeWrapper "$out/bin/nm-viavpn-service" "$out/bin/aruba-nm-viavpn-service" \
      --prefix LD_LIBRARY_PATH : "$libPath"

    # Criar symlinks para compatibilidade
    ln -sf "$out/bin/aruba-via-ui" "$out/bin/via-ui" 2>/dev/null || true
    ln -sf "$out/bin/aruba-via-cli" "$out/bin/via-cli" 2>/dev/null || true

    # Testar se o via-cli funciona agora
    echo "Testando via-cli..."
    if timeout 5s "$out/bin/aruba-via-cli" --help > /dev/null 2>&1; then
      echo "SUCESSO: via-cli funcionando!"
    else
      echo "AVISO: via-cli ainda pode ter problemas"
    fi
  '';
  dontWrapQtApps = true;
  meta = with lib; {
    description =
      "HP Aruba VIA (reempacotado do .deb) – execução via loader Nix";
    homepage = "https://www.arubanetworks.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "aruba-via-ui";
  };
}
