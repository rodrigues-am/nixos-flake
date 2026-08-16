{ pkgs, ... }:
{
  # A configuração em ~/.config/quickshell é um repositório Git independente.
  # O Home Manager instala o programa e supervisiona o processo, mas não deve
  # substituir o shell.qml personalizado por um ponto de entrada próprio.
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
