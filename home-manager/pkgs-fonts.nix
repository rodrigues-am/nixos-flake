{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # fonts
    dejavu_fonts
    emacs-all-the-icons-fonts
    font-awesome
    comic-relief
    google-fonts

    (nerdfonts.override {
      fonts = [ "JetBrainsMono" "FiraCode" "Iosevka" "Noto" ];
    })
  ];

}
