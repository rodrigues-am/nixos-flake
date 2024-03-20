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

    # r
    # R
    # rstudio

    # rust
    rustc
    #rustup
    rustfmt
    rust-analyzer
    cargo

    #nodejs
    nodejs_21

    #Web
    html-tidy
    stylelint
    nodePackages.js-beautify

    jq # lightweight and flexible command-line JSON processor

    #Nix
    nixfmt

    #Yaml
    yaml-language-server

  ]) ++ (with pkgs-stable;
    [

      nodePackages.grammarly-languageserver

    ]);

  # services.postgresql.enable = true;

}
