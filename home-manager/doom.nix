{ config, lib, pkgs, ... }:

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
    #  "emacs" = {
    #    source = builtins.fetchGit {
    #       url = "https://github.com/hlissner/doom-emacs";
    #        ref = "master";
    #    };
    #    onChange = "${pkgs.writeShellScript "doom-change" ''
    #     export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
    #     export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
    #      if [ ! -d "$DOOMLOCALDIR" ]; then
    #        ${config.xdg.configHome}/emacs/bin/doom -y install
    #      else
    #        ${config.xdg.configHome}/emacs/bin/doom -y sync -u
    #      fi
    #    ''
    #    }";
    #  };
    };
  };



}
