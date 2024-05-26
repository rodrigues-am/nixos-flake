{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  home.packages = (with pkgs; [

    age # encryption
    aspell
    aspellDicts.en
    aspellDicts.pt_BR
    auctex # text
    bat
    calibre
    cmake
    curl
    element-desktop
    eza
    fd
    firefox # web browser
    fzf
    gh
    gnome.gucharmap
    #gnucash
    gnumake
    gnupg
    gnuplot
    graphviz # build diagrams declaratively
    htop
    hugo # blog and static sities
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.pt_BR
    libreoffice
    maim # command-line screenshot utility to emacs
    mpv # media player
    neofetch
    neovim
    pandoc
    poppler_utils
    pass
    pdftk
    plantuml # build diagrams declaratively
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
    zip
    zoom-us
    zotero

  ]) ++ (with pkgs-stable; [
    gnomeExtensions.forge
    nyxt # web browser
  ]);

}
