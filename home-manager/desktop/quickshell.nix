{ pkgs, ... }:
{
  home.file.".config/quickshell/shell.qml".source = ../resources/quickshell/shell.qml;

  programs.quickshell = {
    enable = true;
  };

  # O target é iniciado pelo callback Lua do Hyprland depois de importar
  # o ambiente D-Bus/Wayland. O serviço evita processos duplicados e
  # reinicia o shell caso o compositor o derrube.
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell desktop shell";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell --no-duplicate";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}
