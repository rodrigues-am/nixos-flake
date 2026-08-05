{
  config,
  lib,
  pkgs,
  machineName,
  userSettings,
  ...
}:

let
  theme = config.colorScheme.palette;
  homeDir = "/home/${userSettings.name}";
  isNvidia = machineName == "home-desktop";

  monitor =
    if machineName == "home-desktop" then
      {
        output = "HDMI-A-1";
        mode = "2560x1080@60";
        position = "0x0";
        scale = "1";
      }
    else
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "1";
      };

  polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  wallpaper = "${userSettings.wallpaperDir}/battery-gruvbox.png";

  luaConfig = builtins.replaceStrings
    [
      "@terminal@"
      "@browser@"
      "@editor@"
      "@isNvidia@"
      "@monitorOutput@"
      "@monitorMode@"
      "@monitorPosition@"
      "@monitorScale@"
      "@homeDir@"
      "@activeBorderA@"
      "@activeBorderB@"
      "@inactiveBorderA@"
      "@inactiveBorderB@"
      "@polkitAgent@"
      "@wallpaper@"
    ]
    [
      userSettings.term
      userSettings.browser
      userSettings.editor
      (if isNvidia then "true" else "false")
      monitor.output
      monitor.mode
      monitor.position
      monitor.scale
      homeDir
      theme.base0C
      theme.base0D
      theme.base00
      theme.base01
      polkitAgent
      wallpaper
    ]
    (builtins.readFile ./hyprland-lua.lua);
in
{
  # Este módulo substitui a árvore Hyprlang do módulo-base pela
  # configuração Lua canônica do Hyprland 0.55+. As opções mkForce
  # anulam settings e extraConfig do módulo-base.
  wayland.windowManager.hyprland = {
    configType = lib.mkForce "lua";
    settings = lib.mkForce { };
    extraConfig = lib.mkForce luaConfig;
  };
}
