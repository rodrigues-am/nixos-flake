{ pkgs, ... }:
{
  home.file.".config/quickshell/shell.qml".source = ../resources/quickshell/shell.qml;

  programs.quickshell = {
    enable = true;
  };

  # O callback Lua inicia o serviço depois de importar o ambiente
  # D-Bus/Wayland. Não ligar o serviço diretamente ao target: o target
  # sobe antes do callback e poderia iniciar o QuickShell sem Wayland.
  # O serviço evita processos duplicados e reinicia o shell se necessário.
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell desktop shell";
      PartOf = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell --no-duplicate";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
