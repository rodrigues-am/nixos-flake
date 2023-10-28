{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [


#  (pkgs.emacsWithPackagesFromUsePackage {
 #     package = pkgs.emacs29;  # replace with pkgs.emacsPgtk, or another version if desired.
  #    config = ~/.config/home-manager/emacs/init.el;
      # config = path/to/your/config.org; # Org-Babel configs also supported

      # Optionally provide extra packages not in the configuration file.
     # extraEmacsPackages = epkgs: [
     #   epkgs.use-package;
     # ];
(pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
#    extraEmacsPackages = epkgs: with epkgs; [
      adaptive-wrap
      adaptive-wrap
      all-the-icons-dired
      all-the-icons-ivy-rich
      all-the-icons
      amx
      anaconda-mode
      annalist
      anzu
      auctex
      auto-minor-mode
      auto-yasnippet
      avy
      better-jumper
      biblio
      browse-at-remote
      burly
     # centered-window-mode
      centered-window
      cfrs
     # citeproc-el
      citeproc
      citeproc-org
      cmake-mode
      company-anaconda
      company-auctex
      company-glsl
      company-math
     # company-mode
      company
      company-reftex
      company-shell
      company-web
      compat
      consult
      consult-dir
      consult-flycheck
      counsel-jq
      counsel-projectile
      cuda-mode
      dash
      demangle-mode
      dired-git-info
      dired-rsync
      diredfl
      disaster
      doom-modeline
      doom-themes
      drag-stuff
      dtrt-indent
      dumb-jump
      edit-indirect
      ednc
      el-get
      eldoc
      elfeed
      elfeed-goodies
      elfeed-org
      elisp-def
      elisp-demos
      elisp-refs
      # emacs-async
      async
      bash-completion
      buttercup
      ccls
      company-dict
      counsel-css
      ctable
      deferred
      emojify
      fish-completion
      format-all
      hide-mode-line
      htmlize
      kv
      # libvterm
      load-env-vars
      pug-mode
      python-pytest
      request
      slime
      solaire-mode
      undo-fu
      undo-fu-session
      web-server
      websocket
      wgrep
      which-key
      zmq
     # emacsmirror-mirror
      emacsql
      embark
      embrace
      emmet-mode
      epl
      eros
      esh-help
      eshell-did-you-mean
      eshell-syntax-highlighting
      eshell-up
      eshell-z
      ess
      ess-R-data-view
      esxml
      evil
      evil-anzu
      evil-args
      evil-collection
      evil-easymotion
      evil-embrace
      evil-escape
      evil-exchange
      evil-goggles
      evil-indent-plus
      evil-lion
      evil-markdown
      evil-nerd-commenter
      evil-numbers
      org-evil
      # evil-quick-diff
      evil-snipe
      evil-surround
      evil-tex
      evil-textobj-anyblock
      evil-traces
      evil-vimish-fold
      evil-visualstar
      exato
      expand-region
      # explain-pause-mode
      f
      fd-dired
      flycheck
      flycheck-cask
      flycheck-package
      flycheck-plantuml
      flycheck-popup-tip
      font-utils
      fringe-helper
      gcmh
      general
      git-gutter
      git-gutter-fringe
      git-modes
      git-timemachine
      glsl-mode
      elpa-mirror
      gnuplot
      gnuplot-mode
      gnu-elpa
      goto-chg
      golden-ratio
      google-translate
      grammarly
      grip-mode
      haml-mode
      helm-bibtex
      helpful
      highlight-numbers
      highlight-quoted
      hl-todo
      ht
      hydra
      ibuffer-projectile
      ibuffer-vc
      iedit
      ivy-rich
      ivy-xref
      jade-mode
      js2-mode
      js2-refactor
      json-mode
      json-snatcher
      jupyter
      latex-preview-pane
      link-hint
      list-utils
      lsp-grammarly
      lsp-ivy
      lsp-mode
      lsp-python-ms
      lsp-ui
      macrostep
      magit
      magit-todos
      ## "map"
      marginalia
      markdown-mode
      markdown-toc
      math-symbol-lists
      # melpa
      modern-cpp-font-lock
      multiple-cursors
      nerd-icons
      ob-nix
      nixos-options
      nix-mode
      nix-update
      nodejs-repl
      #nongnu-elpa
      # nose
      npm-mode
      ob-async
      ob-sql-mode
      opencl-mode
      openwith
      orderless
      org
      org-appear
      org-cliplink
      org-contrib
      org-download
      org-fancy-priorities
      org-journal
      org-noter
      org-pdftools
      org-ql
      org-re-reveal
      org-ref
      org-roam
      org-roam-ui
      org-super-agenda
      org-superstar
      org-tree-slide
      # org-yt
      orgit
      ov
      overseer
      ox-clip
      ox-hugo
      ox-pandoc
      package-lint
      parent-mode
      parsebib
      pcache
      pcre2el
      pdf-tools
      peg
      persistent-soft
      persp-mode
      pfuture
      pip-requirements
      pipenv
      pkg-info
      plantuml-mode
      poly-markdown
      poly-noweb
      poly-R
      polymode
      popup
      popwin
      posframe
      powerline
      project
      projectile
      psgml
      py-isort
      pyimport
      pythonic
      pyvenv
      queue
      quickrun
      rainbow-delimiters
      rainbow-mode
      restart-emacs
      ox-reveal
      rjsx-mode
      rust-mode
      rustic
      s
      sass-mode
      saveplace-pdf-view
      shrink-path
      shut-up
      skewer-mode
      sly
      sly-macrostep
      sly-repl-ansi-color
      smartparens
      # snippets
      spinner
      # straight
      string-inflection
      swiper
      tablist
      # themes
      tide
      toc-org
      tomelr
      transient
      treemacs
      ts
      typescript-mode
      ucs-utils
      undo-tree
      unicode-fonts
      use-package
      vertico
      vi-tilde-fringe
      vimish-fold
      vundo
      web-completion-data
      web-mode
      wgrep
      with-editor
      which-key
      ws-butler
      xref
      xref-js2
      #xslide
      # xslt-process
      xterm-color
      yaml-mode
      yasnippet
      zotxt
      zotero
])))
   # ];
   # })
    ];
}
