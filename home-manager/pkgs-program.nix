{ config, lib, pkgs, pkgs-stable, inputs, ... }:
with pkgs-stable;
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
    latex2exp
    stringr

    #API
    openalexR
    coro
    covr
    bibliometrix

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
    ggtext

    showtext

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
    lattice
    latticeExtra

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
    # database
    sqlite
    # surrealdb
    postgresql

    # general
    postman
    #surrealdb

    # sh
    shellcheck
    shfmt

    # common-lisp
    sbcl
    rlwrap

    # python

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
    nixd

    #Yaml
    yaml-language-server
    yamlfmt

  ]) ++ (with pkgs-stable; [
    # programing
    python3Full
    RStudio-with-my-packages
    # R
    R-with-my-packages
    #rstudioWrapper
    igraph
    #nodejs
    nodejs_22
    yarn

    #    nodePackages.grammarly-languageserver
    #Cliente DB para o IFUSP
    dbeaver-bin
  ]);

}
