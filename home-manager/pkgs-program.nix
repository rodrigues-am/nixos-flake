{ config, lib, pkgs, pkgs-stable, inputs, ... }:
with pkgs;
let
  pacotesR = with rPackages; [
    # geral
    lubridate
    tufte
    pander
    purrr
    tibble
    jsonlite
    pdftools
    pdfsearch
    descr
    xml2
    knitr
    standardize

    # organização e limpeza
    dplyr
    tidyr
    tidytext
    stringr
    stringi
    gsheet
    glue
    readr
    gtools

    # tables
    gtable
    tableone
    gt
    gtExtras
    gtsummary
    huxtable
    kableExtra
    xtable

    # modelo
    lavaan
    lavaanPlot
    mirt
    psych
    MASS
    mice
    lme4
    forcats
    networkD3
    #difNLP
    ShinyItemAnalysis
    CTT
    lmerTest

    # Graph
    igraph
    tidygraph
    intergraph
    ggraph
    ggnetwork
    widyr
    GGally
    ggnetwork
    netCoin

    # topic NLP
    NLP
    topicmodels
    SnowballC
    tm

    # plot
    ggplot2
    ggthemes
    ggrepel
    hrbrthemes
    viridis
    plotly
    plotrix
    visdat

  ];
  RStudio-with-my-packages = rstudioWrapper.override {
    packages = pacotesR;

  };
  R-with-my-packages = rWrapper.override {
    packages = pacotesR;

  };

in {

  home.packages = (with pkgs; [
    # programing
    RStudio-with-my-packages
    # R
    R-with-my-packages
    #rstudioWrapper

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

    #Cliente DB para o IFUSP
    dbeaver
  ]);

  # services.postgresql.enable = true;

}
