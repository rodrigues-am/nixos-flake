{ config, lib, pkgs, pkgs-stable, inputs, ... }: {

  home.packages = (with pkgs; [
    dpkg
    (aspellWithDicts (d: with d; [ en pt_BR ]))
    #oauth2ms
    #calibre
    age # encryptionc
    #aspell
    #aspellDicts.en
    #aspellDicts.pt_BR
    auctex # text
    bat
    binutils
    bottles # wine prefix manager
    # blender
    cmake
    curl
    dig
    element-desktop
    eza
    fd
    firefox # web browser
    # fontforge-gtk
    fzf
    gcc
    gh
    ghostscript
    gnome-themes-extra
    gnome-tweaks
    gnomeExtensions.user-themes
    gnumake
    gnupg
    gnuplot
    gnutar
    graphviz # build diagrams declaratively
    gtk-engine-murrine
    gucharmap
    fastfetch
    htop
    hugo # blog and static sities
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    inkscape-with-extensions
    jp2a
    libreoffice
    libtool
    libvterm
    libxml2
    lsof
    maim # command-line screenshot utility to emacs
    mautrix-whatsapp
    mpv # media player
    #mu
    neovim
    ocrmypdf
    pandoc
    pass
    patchelf
    pdftk
    pkg-config
    plantuml # build diagrams declaratively
    poppler-utils
    ranger # file manager
    ripgrep
    sassc
    searxng
    shotwell
    sops
    stow
    syncthing
    texlive.combined.scheme-full # latex
    tree
    unzip
    wget
    xclip
    xournalpp # pdf edit
    #    wine
    wine-wayland
    winetricks
    wlr-randr
    zathura # pdf viwer
    zellij
    zip
    #zoom-us
    zotero
    zoxide

    libxcvt

    # Proton VPN com override para versão mais recente
  ]) ++ (with pkgs-stable; [

    audacity
    brave
    calibre
    darktable
    ffmpeg_6-full
    gimp-with-plugins
    gnomeExtensions.forge
    imagemagick
    krita
    ntfs3g
    nyxt # web browser
    tesseract4
    vulkan-tools
    jre8
  ]);

}
