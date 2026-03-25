{
  config,
  userSettings,
  ...
}:

{
  # --- CONFIGURAÇÃO DE REDE NO HOST ---
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
      # 2. Pasta de Segredos do SOPS (Necessário para o link .env funcionar)
      "/run/secrets/rendered" = {
        hostPath = "/run/secrets/rendered";
        isReadOnly = true;
      };
    };

    # --- CONFIGURAÇÃO INTERNA DO GUEST ---
    config =
      { pkgs, ... }:
      {
        i18n.defaultLocale = "pt_BR.UTF-8";
        services.xserver.xkb = {
          layout = "us";
          variant = "intl";
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

            # WorkingDirectory = "/home/${userSettings.name}/sync/pessoal/hermes-agent";

            Restart = "always";
            RestartSec = "10s";
            User = "root";

            Environment = [
              # "PATH=/home/${userSettings.name}/sync/pessoal/hermes-agent/venv/bin:/run/current-system/sw/bin:/usr/bin:/bin"
              # "PYTHONPATH=/home/${userSettings.name}/sync/pessoal/hermes-agent"
              "PYTHONUNBUFFERED=1"
            ];

            # EnvironmentFile = "/home/${userSettings.name}/sync/pessoal/hermes-agent/.env";
          };

        };

        system.stateVersion = "24.11";
      };
  };

  # --- INTEGRAÇÃO COM SOPS (No Host) ---
  sops.templates."hermes.env" = {
    path = "/home/${userSettings.name}/sync/pessoal/hermes-agent/.env";
    owner = userSettings.name;
    content = ''
      TELEGRAM_BOT_TOKEN=${config.sops.placeholder.telegram_token}
      ALLOWED_TELEGRAM_IDS=${builtins.toString config.sops.placeholder.telegram_id}
      OPENROUTER_API_KEY=${config.sops.placeholder.openrouter_token}
      OPENAI_API_KEY=${config.sops.placeholder.openai_key}
      FIRECRAWL_API_KEY=${config.sops.placeholder.firecrawl_token}
    '';
  };

  # --- UTILITÁRIOS E ALIASES ---
  programs.bash.shellAliases = {
    hermes = "sudo nixos-container run hermes -- hermes";
    hermes-logs = "sudo nixos-container run hermes -- journalctl -u hermes-gateway -f";
    hermes-status = "sudo nixos-container run hermes -- systemctl status hermes-gateway";
  };

  # Cedilha no Host
  systemd.tmpfiles.rules = [
    "L+ /home/${userSettings.name}/.XCompose - - - - /home/${userSettings.name}/sync/pessoal/hermes-agent/.XCompose"
  ];
}
