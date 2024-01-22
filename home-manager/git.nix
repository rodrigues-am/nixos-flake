{ config, lib, pkgs, inputs, userSettings, ... }: {

  programs.git = {
    enable = true;
    userName = "${userSettings.gitUser}";
    userEmail = "${userSettings.email}";

  };

}
