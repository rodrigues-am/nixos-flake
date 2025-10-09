{ config, ... }:

{

  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };

  };
  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".source = ./emacs/config.el;
      "doom-config/init.el".source = ./emacs/init.el;
      "doom-config/packages.el".source = ./emacs/packages.el;
    };
  };

}
