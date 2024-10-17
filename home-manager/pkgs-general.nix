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
    calibre
    cmake
    curl
    element-desktop
    eza
    fd
    firefox # web browser
    fontforge-gtk
    fzf
    gh
    ghostscript
    gucharmap
    gnumake
    gnupg
    gnuplot
    graphviz # build diagrams declaratively
    htop
    hugo # blog and static sities
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    inkscape-with-extensions
    libreoffice
    maim # command-line screenshot utility to emacs
    mpv # media player
    neofetch
    neovim
    pandoc
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
    xournal # pdf edit
    zathura # pdf viwer
    zellij
    zip
    zoom-us
    zotero
    zoxide
  ]) ++ (with pkgs-stable; [
    gnomeExtensions.forge
    gimp-with-plugins
    ffmpeg_6-full
    darktable
    imagemagick
    ntfs3g
    nyxt # web browser
  ]);

}
