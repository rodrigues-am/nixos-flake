{ userSettings, ... }: {

  programs.git = {
    enable = true;
    settings.user.name = "${userSettings.gitUser}";
    settings.user.email = "${userSettings.email}";

  };

}
