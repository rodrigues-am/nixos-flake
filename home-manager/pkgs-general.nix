{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [

    age # encryption
    alacritty # terminal
    aspell
    aspellDicts.en
    aspellDicts.pt_BR
    auctex # text
    bat
    brave # web browser
    calibre
    cmake
    curl
    element-desktop
    eza
    fd
    firefox # web browser
    fzf
    gh
    git
    gnome.gucharmap
    gnucash
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
    nyxt # web browser
    pandoc
    pass
    pdftk
    plantuml # build diagrams declaratively
    ranger # file manager
    ripgrep
    sops
    starship # terminal prompt
    stow
    syncthing
    texlive.combined.scheme-full # latex
    unzip
    wget
    xclip
    xournal # pdf edit
    zathura # pdf viwer
    zip
    zoom
    zotero

  ];

}
