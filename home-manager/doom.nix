{ config, lib, pkgs, ... }:

{
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };

    packages = with pkgs; [

      emacs29-pgtk
      isync
      msmtp
      emacsPackages.nerd-icons
      emacsPackages.pdf-tools
      emacsPackages.vterm
      (pkgs.mu.override { emacs = emacs29-pgtk; })
      emacsPackages.mu4e
    ];

  };

  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".source = ./emacs/config.el;
      "doom-config/init.el".source = ./emacs/init.el;
      "doom-config/packages.el".source = ./emacs/packages.el;
    };
  };

  # services.mbsync = {
  #     enable = true;
  #     package = pkgs.isync;
  #     frequency = "*:0/5";
  #   };

  programs.emacs.enable = true;
}
