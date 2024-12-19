{ pkgs ? import <nixpkgs> { } }:

# pkgs.stdenv.mkDerivation {
#   name = "via-cli";

#   # O arquivo .deb precisa estar disponível no sistema
#   src = ./via-aruba.deb; # Substitua pelo caminho correto

#   nativeBuildInputs = [
#     pkgs.patchelf
#     pkgs.binutils
#     pkgs.gnutar
#     pkgs.zlib
#     pkgs.libxml2
#     pkgs.libproxy
#     pkgs.dbus
#     # pkgs.qt5.qtbase
#   ];
#   dontUnpack = true;
#   dontBuild = true;
#   dontWrapQtApps = true;

#   installPhase = ''
#     echo "Instalando via-aruba e ajustando via-ui..."

#     # Diretório de saída
#     mkdir -p $out/bin

#     # Extrair o .deb usando ar e tar
#     ar x $src
#     tar -xvf data.tar.* -C $out

#     # Ajustar o binário via-cli
#     if [ -f $out/usr/bin/via-ui ]; then
#       mv $out/usr/bin/via-cli $out/bin/via-cli
#       patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/via-cli
#       patchelf --set-rpath "${pkgs.glibc}/lib:${pkgs.zlib}/lib:${pkgs.libxml2}/lib:${pkgs.libproxy}/lib:${pkgs.dbus}/lib:${pkgs.qt5.qtbase}/lib:$out/lib:$out/usr/lib" $out/bin/via-cli

#     else
#       echo "Erro: via-cli não encontrado no pacote .deb"
#       exit 1
#     fi

#     echo "Instalação e ajustes concluídos!"
#   '';
# }

# installPhase = ''
#     echo "Instalando via-aruba e ajustando via-ui..."

#     # Diretório de saída
#     mkdir -p $out/bin

#     # Extrair o .deb usando ar e tar
#     ar x $src
#     tar -xvf data.tar.* -C $out

#     # Ajustar o binário via-ui
#     if [ -f $out/usr/bin/via-ui ]; then
#       mv $out/usr/bin/via-ui $out/bin/via-ui
#       patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/via-ui
#       patchelf --set-rpath "${pkgs.glibc}/lib:${pkgs.zlib}/lib:${pkgs.libxml2}/lib:${pkgs.libproxy}/lib:${pkgs.dbus}/lib:${pkgs.qt5.qtbase}/lib:$out/lib:$out/usr/lib" $out/bin/via-ui

#     else
#       echo "Erro: via-ui não encontrado no pacote .deb"
#       exit 1
#     fi

#     echo "Instalação e ajustes concluídos!"
#   '';
# }

# pkgs.stdenv.mkDerivation {
#   name = "via-aruba";
#   src = ./via-aruba.deb;
#   buildInputs = [ pkgs.binutils pkgs.gnutar ]; # Para o comando `ar`
#   dontUnpack = true;
#   dontBuild = true;
#   installPhase = ''
#     echo "Extraindo o arquivo via-aruba.deb..."
#     mkdir -p $out
#     ar x $src
#     tar -xvf data.tar.* -C $out
#   '';

#}
