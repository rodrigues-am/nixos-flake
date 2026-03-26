{
  config,
  userSettings,
  ...
}:

{
  # # --- CONFIGURAÇÃO DE REDE NO HOST ---
  networking.firewall.trustedInterfaces = [ "ve-hermes" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-hermes" ];
    # Certifique-se que wlan0 é sua interface de internet ativa
    externalInterface = "wlan0";
  };

  # --- DEFINIÇÃO DO CONTAINER ---
  containers.hermes = {
    autoStart = true;
    privateNetwork = false;

    bindMounts = {
      # 1. Pasta do Agente (Caminho idêntico ao Host para manter o venv funcional)
      "/home/${userSettings.name}/sync/pessoal/hermes-agent" = {
        hostPath = "/home/${userSettings.name}/sync/pessoal/hermes-agent";
        isReadOnly = false;
      };
    };

    # --- CONFIGURAÇÃO INTERNA DO GUEST ---
    config =
      { pkgs, ... }:
      {
        i18n.defaultLocale = "pt_BR.UTF-8";
        environment.sessionVariables = {
          XKB_DEFAULT_LAYOUT = "br";
          XKB_DEFAULT_VARIANT = "abnt2";
        };
        # Configure console keymap
        console.keyMap = "us-acentos";
        # Suporte a binários externos (essencial para o Hermes)
        programs.nix-ld.enable = true;
        documentation.enable = false;

        networking.nameservers = [
          "8.8.8.8"
          "1.1.1.1"
        ];

        environment.systemPackages = with pkgs; [
          git
          curl
          python311
          nodejs_22
          ripgrep
          ffmpeg
          bash
          cacert
          himalaya # para o gerenciamento do e-mail
        ];

        # ARQUIVO .XCompose (Cedilha dentro do container)
        environment.etc."XCompose".text = ''
          include "/%L"
          <Multi_key> <'> <c> : "ç"
          <Multi_key> <Shift> <'> <c> : "Ç"
        '';
        # Isso faz o Hermes achar que está na pasta padrão,
        # mas na verdade ele está lendo sua pasta Sync!
        systemd.tmpfiles.rules = [
          "L+ /root/.XCompose - - - - /etc/XCompose"
        ];

        # SERVIÇO DO GATEWAY (O Servidor)
        systemd.services.hermes-gateway = {
          description = "Hermes Agent Gateway Service";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            # O segredo é chamar o executável do python e passar o script depois
            ExecStart = "/root/.local/bin/hermes gateway";

            Restart = "always";
            RestartSec = "10s";
            User = "root";

          };

        };

        system.stateVersion = "24.11";
      };
  };

  # --- UTILITÁRIOS E ALIASES ---
  programs.bash.shellAliases = {
    hermes = "sudo nixos-container run hermes -- hermes";
    hermes-logs = "sudo nixos-container run hermes -- journalctl -u hermes-gateway -f";
    hermes-status = "sudo nixos-container run hermes -- systemctl status hermes-gateway";
  };

}
