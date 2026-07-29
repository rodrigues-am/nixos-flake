{
  config,
  pkgs,
  userSettings,
  ...
}:
let
  user = userSettings.name;
  stateDir = "/home/${user}/.local/share/hermes-agent";
  hermesHome = "${stateDir}/.hermes";
  workspace = "${stateDir}/workspace";

  # Runtime estável para os jobs determinísticos do cradle-news. Os wrappers
  # não devem depender do venv interno de uma versão específica do Hermes.
  cradleNewsPython = pkgs.python3.withPackages (ps: with ps; [
    google-api-python-client
    google-auth
    pytest
  ]);

  # Runtime compartilhado pelos gateways e pelo dashboard. O serviço principal
  # do módulo constrói sua própria variante equivalente com messaging.
  hermesRuntime = config.services.hermes-agent.package.override {
    extraDependencyGroups = [
      "messaging"
      "web"
    ];
  };

  servicePath = with pkgs; [
    hermesRuntime
    age
    bash
    coreutils
    curl
    fd
    ffmpeg
    findutils
    git
    gnugrep
    gnused
    graphviz
    imagemagick
    jq
    nodejs_22
    pandoc
    poppler-utils
    cradleNewsPython
    ripgrep
    sops
    systemd
    tesseract
    wget
    yq-go
    yt-dlp
  ];

  commonEnvironment = {
    HERMES_HOME = hermesHome;
    HERMES_MANAGED = "true";
    HOME = stateDir;
  };
in
{
  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    inherit user;
    group = user;
    createUser = false;

    # Não usar /home/andre como stateDir: o módulo aplica modo 2770 ao
    # stateDir e isso faz o OpenSSH rejeitar ~/.ssh por StrictModes.
    # ~/.hermes é mantido como link para este estado persistente.
    inherit stateDir;
    workingDirectory = workspace;
    extraDependencyGroups = [ "messaging" ];

    extraPackages = with pkgs; [
      age
      bash
      curl
      chromium
      emacs-nox
      fd
      ffmpeg
      git
      graphviz
      imagemagick
      jq
      nodejs_22
      pandoc
      poppler-utils
      cradleNewsPython
      ripgrep
      sops
      tesseract
      wget
      yq-go
      yt-dlp
    ];

    # settings = {
    #   model = {
    #     provider = "ollama-cloud";
    #     default = "glm-5.2";
    #   };
    #   toolsets = [ "all" ];
    #   agent.max_turns = 150;
    #   terminal = {
    #     backend = "local";
    #     cwd = "/home/${user}";
    #     timeout = 180;
    #   };
    #   memory = {
    #     memory_enabled = true;
    #     user_profile_enabled = true;
    #   };
    # };

    restart = "always";
    restartSec = 5;
  };

  # A versão atual do módulo expõe environment/environmentFiles como opções,
  # mas não as transfere para a unidade gerada. Aplique-os diretamente ao
  # serviço systemd para habilitar a API OpenAI compatível do gateway padrão.
  systemd.services.hermes-agent = {
    environment = {
      API_SERVER_ENABLED = "true";
      API_SERVER_HOST = "0.0.0.0";
      API_SERVER_PORT = "8642";
    };
    serviceConfig.EnvironmentFile = config.sops.templates."hermes-api-server.env".path;
  };

  # O Secretario usa o .env mutável do próprio perfil; seu antigo bloco SOPS
  # foi removido sem impedir que o perfil continue sendo um Hermes normal.
  systemd.services.hermes-agent-secretario = {
    description = "Hermes Agent Gateway - Secretario profile";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = servicePath;
    environment = commonEnvironment;
    serviceConfig = {
      Type = "simple";
      User = user;
      Group = user;
      WorkingDirectory = "/home/${user}";
      ExecStart = "${hermesRuntime}/bin/hermes -p secretario gateway";
      Restart = "always";
      RestartSec = 5;
      KillMode = "control-group";
      UMask = "0007";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = false;
      ProtectSystem = "strict";
      ReadWritePaths = [
        stateDir
        "/home/${user}"
      ];
    };
  };

  # O Hermes Desktop conecta-se ao dashboard, não ao gateway de mensageria.
  # A porta não é aberta para a LAN; tailscale0 é uma interface confiável.
  systemd.services.hermes-dashboard = {
    description = "Hermes Dashboard - remote backend over Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = servicePath;
    environment = commonEnvironment;
    serviceConfig = {
      Type = "simple";
      User = user;
      Group = user;
      WorkingDirectory = workspace;
      ExecStart = "${hermesRuntime}/bin/hermes dashboard --host 0.0.0.0 --port 9119 --no-open";
      Restart = "always";
      RestartSec = 5;
      KillMode = "control-group";
      UMask = "0007";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = false;
      ProtectSystem = "strict";
      ReadWritePaths = [
        stateDir
        "/home/${user}"
      ];
    };
  };
}
