{
  pkgs,
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

  systemd.tmpfiles.rules = [
    # "a+" garante que as permissões de escrita sejam herdadas (ACL)
    # Isso diz: "Tudo que for criado nesta pasta deve dar permissão RW ao grupo users"
    "d /home/${userSettings.name}/sync/pessoal/hermes-agent 0775 ${userSettings.name} users - -"
    "a+ /home/${userSettings.name}/sync/pessoal/hermes-agent - - - - group:users:rwx,default:group:users:rwx"

    # Repita para a pasta de configurações específicas
    "d /home/${userSettings.name}/sync/pessoal/hermes-agent/.hermes 0775 ${userSettings.name} users - -"
    "a+ /home/${userSettings.name}/sync/pessoal/hermes-agent/.hermes - - - - group:users:rwx,default:group:users:rwx"
  ];

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

      # 1. Pasta do Agente (Caminho idêntico ao Host para manter o venv funcional)
      "/home/${userSettings.name}/sync" = {
        hostPath = "/home/${userSettings.name}/sync";
        isReadOnly = true;
      };

      "/home/${userSettings.name}/Zotero" = {
        hostPath = "/home/${userSettings.name}/Zotero";
        isReadOnly = true;
      };

      "/home/${userSettings.name}/nixos-flake" = {
        hostPath = "/home/${userSettings.name}/nixos-flake";
        isReadOnly = true;
      };
      # Montamos a pasta de configuração diretamente no local que o Hermes espera
      "/root/.hermes" = {
        hostPath = "/home/${userSettings.name}/sync/pessoal/hermes-agent/.hermes";
        isReadOnly = false;
      };

      # # 2. permite seguir o secrets
      "/run/secrets/" = {
        hostPath = "/run/secrets/";
        isReadOnly = true;
      };

      # 3. pasta de leitura para obter informações
      "/home/${userSettings.name}/notas" = {
        hostPath = "/home/${userSettings.name}/notas";
        isReadOnly = true;
      };

    };

    # --- CONFIGURAÇÃO INTERNA DO GUEST ---
    config =
      { pkgs, ... }:
      {

        # Set your time zone.
        time.timeZone = "America/Sao_Paulo";

        # Select internationalisation properties.
        i18n.defaultLocale = "${userSettings.locale}";

        i18n.extraLocaleSettings = {
          LANGUAGE = "${userSettings.locale}:pt:en";
          LC_ADDRESS = "${userSettings.locale}";
          LC_IDENTIFICATION = "${userSettings.locale}";
          LC_MEASUREMENT = "${userSettings.locale}";
          LC_MONETARY = "${userSettings.locale}";
          LC_NAME = "${userSettings.locale}";
          LC_NUMERIC = "${userSettings.locale}";
          LC_PAPER = "${userSettings.locale}";
          LC_TELEPHONE = "${userSettings.locale}";
          LC_TIME = "${userSettings.locale}";
          LC_ALL = "${userSettings.locale}";
        };

        environment.sessionVariables = {
          GTK_IM_MODULE = "cedilla";
          QT_IM_MODULE = "cedilla";
        };

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
          R
          bash
          cacert
          calibre
          curl
          direnv
          emacs30-pgtk
          fd
          ffmpeg
          fzf
          git
          graphviz
          himalaya # para o gerenciamento do e-mail
          hugo
          imagemagick
          jp2a
          jq
          nodejs_22
          pandoc
          pdftk
          plantuml
          poppler-utils
          python311
          rclone
          ripgrep
          tesseract4
          wget
          yq
          yt-dlp
          zoxide
          honcho
          kbd
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
        # systemd.services.hermes-gateway = {
        #   description = "Hermes Agent Gateway Service";
        #   after = [ "network.target" ];
        #   wantedBy = [ "multi-user.target" ];

        #   serviceConfig = {
        #     # O segredo é chamar o executável do python e passar o script depois
        #     ExecStart = "/root/.local/bin/hermes gateway";

        #     Environment = [
        #       # Conexão com o Ollama (Porta padrão 11434)
        #       "OLLAMA_API_BASE=http://127.0.0.1:11434"

        #       # Conexão com o ChromaDB (Porta padrão 8000)
        #       "CHROMA_SERVER_HOST=10.0.0.1"
        #       "CHROMA_SERVER_HTTP_PORT=8000"

        #       # Conexão com o Honcho (Geralmente porta 5000 ou 8080 dependendo do seu app)
        #      # "HONCHO_URL=http:10.0.0.1//:5000"

        #       # Caso o Hermes use uma URL unificada para a base de dados vetorial
        #       "VECTOR_DB_URL=http://127.0.0.1:8000"
        #     ];

        #     Restart = "always";
        #     RestartSec = "10s";
        #     User = "root";

        #     # garante que novos arquivos
        #     # sejam criados com permissões de escrita para o grupo
        #     UMask = "0002";
        #   };

        # };

        system.stateVersion = "26.05";
      };
  };
  # --- No bloco do SOPS ---
  sops.templates."hermes.env" = {
    path = "/home/${userSettings.name}/sync/pessoal/hermes-agent/.hermes/.secrets";
    owner = userSettings.name;
    content = ''
      TELEGRAM_BOT_TOKEN=${config.sops.placeholder.telegram_token}
      ALLOWED_TELEGRAM_IDS=${builtins.toString config.sops.placeholder.telegram_id}
      OPENROUTER_API_KEY=${config.sops.placeholder.openrouter_token_hermes}
      OPENAI_API_KEY=${config.sops.placeholder.openai_key}
      FIRECRAWL_API_KEY=${config.sops.placeholder.firecrawl_token}
      GMAIL_PASSWORD=${config.sops.placeholder.gmail_key}

    '';
  };
  # --- UTILITÁRIOS E ALIASES ---
  programs.bash.shellAliases = {
    hermes = "sudo nixos-container run hermes -- hermes";
    hermes-logs = "sudo nixos-container run hermes -- journalctl -u hermes-gateway -f";
    hermes-status = "sudo nixos-container run hermes -- systemctl status hermes-gateway";
    hermes-root-login = "sudo nixos-container root-login hermes";
    hermes-check-ollama = "sudo nixos-container run hermes -- curl http://127.0.0.1:11434/api/tags";
  };

  #-- Chroma DB para criação de RAGs
  # systemd.services.chromadb = {
  #   description = "ChromaDB Vector Database";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig = {
  #     # 1. Adicionamos o Bash e Coreutils ao PATH do serviço
  #     Environment = [
  #       "PATH=${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.nodejs_22}/bin"
  #     ];

  #     # 2. Mantemos o comando, mas agora ele encontrará o 'sh'
  #     ExecStart = "${pkgs.nodejs_22}/bin/npx -y chromadb run --path /home/${userSettings.name}/sync/pessoal/hermes-agent/.hermes/chroma_data --host 127.0.0.1 --port 8000";

  #     Restart = "always";
  #     User = userSettings.name;
  #   };
  # };

  # #-- Hncho para Hermes, aprimorar a memória
  # systemd.services.honcho-hermes.serviceConfig = {
  #   # Ajuste o WorkingDirectory para onde o código fonte (com a pasta hermes_agent) está
  #   WorkingDirectory = "/home/andre/sync/pessoal/hermes-agent/.hermes/hermes-agent";

  #   # Honcho do nixpkgs do sistema
  #   ExecStart = "${pkgs.honcho}/bin/honcho start -f /home/andre/sync/pessoal/hermes-agent/.hermes/Procfile";

  #   Environment = [
  #     # PATH com python do nixpkgs
  #     "PATH=${pkgs.python311}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.honcho}/bin"

  #     # PYTHONPATH para achar o módulo hermes_agent
  #     "PYTHONPATH=/home/andre/sync/pessoal/hermes-agent/.hermes/hermes-agent"

  #     # Dir de configuração (aponta pro .hermes no sync)
  #     "HERMES_CONFIG_DIR=/home/andre/sync/pessoal/hermes-agent/.hermes"
  #   ];

  #   Restart = "always";
  #   RestartSec = "10s";
  #   User = "andre";
  #   UMask = "0002";
  # };
}
