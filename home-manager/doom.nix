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
    emacsPackages.nerd-icons
    emacsPackages.pdf-tools
    (pkgs.mu.override { emacs = emacs29-pgtk; })
    emacsPackages.mu4e
    isync
    msmtp
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

}
