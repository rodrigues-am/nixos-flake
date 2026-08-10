{ pkgs, ... }:
{
  # Hermes Desktop is packaged as a generic Linux Electron application.
  # nix-ld provides the FHS loader path; these libraries provide the runtime
  # expected by the unpacked binary under ~/.hermes/hermes-agent/apps/desktop.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libgbm
      libglvnd
      libnotify
      libsecret
      libxkbcommon
      nspr
      nss
      pango
      systemd
      wayland
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
    ];
  };
}
