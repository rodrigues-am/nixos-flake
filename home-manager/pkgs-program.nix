{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  home.packages = (with pkgs; [
    # programing

    # database
    sqlite
    #surrealdb
    postgresql

    # general
    #postman

    #sh
    shellcheck
    shfmt

    # common-lisp
    sbcl
    rlwrap

    # python
    python3Full

    # rust
    rustc
    #rustup
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
    # r
    R
    rstudio

    #Cliente DB para o IFUSP
    dbeaver
  ]);

  # services.postgresql.enable = true;

}
