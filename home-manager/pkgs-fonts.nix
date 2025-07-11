{ pkgs-stable, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs-stable; [
    dejavu_fonts
    emacs-all-the-icons-fonts
    font-awesome
    comic-relief
    google-fonts
    (google-fonts.override { fonts = [ "Roboto" ]; })
    (nerdfonts.override {
      fonts = [ "JetBrainsMono" "FiraCode" "Iosevka" "Noto" ];
    })
  ];

}
