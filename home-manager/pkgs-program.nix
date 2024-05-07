{ config, lib, pkgs, pkgs-stable, inputs, ... }:
with pkgs;
let
  RStudio-with-my-packages = rstudioWrapper.override {
    packages = with rPackages; [
      ggplot2
      dplyr
      tidyr
      ggthemes
      gsheet
      tidytext
      stringr
      glue
      ggrepel

    ];
  };
in {

  home.packages = (with pkgs; [
    # programing

    # database
    sqlite
    # surrealdb
    postgresql

    # general
    # postman

    # sh
    shellcheck
    shfmt

    # common-lisp
    sbcl
    rlwrap

    # python
    python3Full

    # rust
    rustc

    # rustup
    rustfmt
    rust-analyzer
    cargo

    #Web
    html-tidy
    stylelint
    nodePackages.js-beautify

    jq # lightweight and flexible command-line JSON processor

    #Nix
    nixfmt-classic

    #Yaml
    yaml-language-server

  ]) ++ (with pkgs-stable; [

    #nodejs
    nodejs_21
    nodePackages.grammarly-languageserver

    # R
    R
    rstudioWrapper
    #Cliente DB para o IFUSP
    dbeaver
  ]);

  # services.postgresql.enable = true;

}
