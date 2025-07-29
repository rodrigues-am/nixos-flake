{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  home.packages = (with pkgs; [
    #oauth2ms
    #calibre
    age # encryptionc
    aspell
    aspellDicts.en
    aspellDicts.pt_BR
    auctex # text
    audacity
    bat
    binutils
    blender
    cmake
    curl
    dig
    element-desktop
    eza
    fd
    firefox # web browser
    fontforge-gtk
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
    htop
    hugo # blog and static sities
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    inkscape-with-extensions
    libreoffice
    libtool
    libvterm
    libxml2
    lsof
    maim # command-line screenshot utility to emacs
    mautrix-whatsapp
    mpv # media player
    #mu
    neofetch
    neovim
    pandoc
    pass
    patchelf
    pdftk
    pkg-config
    plantuml # build diagrams declaratively
    poppler_utils
    ranger # file manager
    ripgrep
    sassc
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
    zathura # pdf viwer
    zellij
    zip
    zoom-us
    zotero
    zoxide
  ]) ++ (with pkgs-stable; [
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
    #wkhtmltopdf
    vulkan-tools
    jre8
  ]);

}
