{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  home.packages = (with pkgs; [
    age # encryption
    aspell
    aspellDicts.en
    aspellDicts.pt_BR
    auctex # text
    audacity
    bat
    binutils
    #calibre
    cmake
    curl
    element-desktop
    eza
    fd
    #firefox # web browser
    fontforge-gtk
    fzf
    gh
    ghostscript
    gucharmap
    gnumake
    gnupg
    gnuplot
    gnutar
    gnome-themes-extra
    gnome-tweaks
    gnomeExtensions.user-themes
    sassc
    gtk-engine-murrine
    graphviz # build diagrams declaratively
    htop
    hugo # blog and static sities
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    inkscape-with-extensions
    libreoffice
    libxml2
    maim # command-line screenshot utility to emacs
    mpv # media player
    neofetch
    neovim
    pandoc
    patchelf
    pass
    pdftk
    plantuml # build diagrams declaratively
    poppler_utils
    ranger # file manager
    ripgrep
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
    jre8
  ]);

}
