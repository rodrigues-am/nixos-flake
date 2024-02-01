{ config, lib, pkgs, userSettings, nix-doom-emacs, nix-colors, ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles = "usp";
  };

  programs.thunderbird = {
    enable = true;
    profiles.${userSettings.name} = { isDefault = true; };
  };

  accounts.email = {
    accounts.outlook = {
      realName = "Andre Rodrigues";
      address = "rodrigues.am83@gmail.com";
      userName = "rodrigues.am83@gmail.com";
      primary = true;
      imap = {
        host = "gmail.com";
        port = 993;
      };
      #passwordCommand = "cat ${config.age.secrets.microsoft.path}";
      thunderbird = {
        enable = true;
        profiles = [ "${current.user}" ];
      };
    };
  };

}
