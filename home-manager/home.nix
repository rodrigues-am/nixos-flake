{
  inputs,
  userSettings,
  nix-doom-emacs,
  nix-colors,
  ...
}:
{

  imports = [
    # programs
    ./programs/aspell.nix
    ./programs/bash.nix
    ./programs/brave.nix
    ./programs/doom.nix
    ./programs/email.nix
    ./programs/git.nix
    ./programs/starship.nix

    # desktop
    ./desktop/alacritty.nix
    ./desktop/espanso.nix
    ./desktop/gtk.nix
    ./desktop/hyprland.nix
    ./desktop/xcompose.nix

    # packages
    ./packages/fonts.nix
    ./packages/general.nix
    ./packages/programs.nix

    # scripts
    ./scripts/doomcapture.nix
    ./scripts/emopicker.nix
    ./scripts/keyboard-layout-status.nix
    ./scripts/keyboard-toggle.nix
    ./scripts/pdftotext.nix
    ./scripts/powermenu.nix
    ./scripts/wallsetter.nix

    inputs.sops-nix.homeManagerModule
    nix-colors.homeManagerModules.default
    nix-doom-emacs.hmModule

  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/.config/sops/age/keys.txt";

  };

  home = {
    username = "${userSettings.name}";
    homeDirectory = "/home/${userSettings.name}";
    stateVersion = "26.11"; # Please read the comment before changing.
    file = { };
    sessionVariables = {
      EDITOR = "${userSettings.editor}";
      TERM = "${userSettings.term}";
      BROWSER = "${userSettings.browser}";
      GTK_IM_MODULE = "cedilla";
      QT_IM_MODULE = "cedilla";
    };

  };

  colorScheme = nix-colors.colorSchemes."${userSettings.theme}";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
