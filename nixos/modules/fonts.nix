{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      font-awesome

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.noto
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [
          "Noto Serif"
          "DejaVu Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Roboto"
          "DejaVu Sans"
        ];
        monospace = [
          "FiraCode Nerd Font Mono"
          "Fira Code"
          "DejaVu Sans Mono"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
