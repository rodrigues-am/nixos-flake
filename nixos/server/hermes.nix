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
  cradleNewsPython = pkgs.python3.withPackages (
    ps: with ps; [
      google-api-python-client
      google-auth
      pytest
    ]
  );

  # Runtime compartilhado pelos gateways e pelo dashboard.
  hermesRuntime = config.services.hermes-agent.package.override {
    extraDependencyGroups = [
      "firecrawl"
      "hindsight"
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
    texliveFull
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
    extraDependencyGroups = [
      "firecrawl"
      "hindsight"
      "messaging"
      "web"
    ];

    settings.memory.provider = "hindsight";

    extraPackages = with pkgs; [
      age
      bash
      chromium
      cradleNewsPython
      curl
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
      ripgrep
      sops
      tesseract
      texliveFull
      wget
      yq-go
      yt-dlp
    ];

    restart = "always";
    restartSec = 5;
  };

  # A versão atual do módulo expõe environment/environmentFiles como opções,
  # mas não as transfere para a unidade gerada. Aplique-os diretamente ao
  # serviço systemd para habilitar a API OpenAI compatível do gateway padrão.
  systemd.services.hermes-agent = {
    after = [ "hindsight-healthcheck.service" ];
    wants = [ "hindsight-healthcheck.service" ];
    environment = {
      API_SERVER_ENABLED = "true";
      API_SERVER_HOST = "0.0.0.0";
      API_SERVER_PORT = "8642";
    };
    serviceConfig.EnvironmentFile = [
      config.sops.templates."hermes-api-server.env".path
      config.sops.templates."hindsight-hermes.env".path
    ];
  };

  # O Secretario usa o .env mutável do próprio perfil; seu antigo bloco SOPS
  # foi removido sem impedir que o perfil continue sendo um Hermes normal.
  systemd.services.hermes-agent-secretario = {
    description = "Hermes Agent Gateway - Secretario profile";
    after = [
      "hindsight-healthcheck.service"
      "network-online.target"
    ];
    wants = [
      "hindsight-healthcheck.service"
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];
    path = servicePath;
    environment = commonEnvironment;
    serviceConfig = {
      Type = "simple";
      User = user;
      Group = user;
      WorkingDirectory = "/home/${user}";
      EnvironmentFile = [ config.sops.templates."hindsight-hermes.env".path ];
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
  #
  # O dashboard administra o config.yaml mutável. O módulo NixOS marca o
  # HERMES_HOME como gerenciado em cada ativação; remova o marcador antes de
  # iniciar o dashboard e não lhe passe HERMES_MANAGED. O gateway principal
  # continua gerenciado declarativamente pelo módulo.
  systemd.services.hermes-dashboard = {
    description = "Hermes Dashboard - remote backend over Tailscale";
    after = [
      "hindsight-healthcheck.service"
      "network-online.target"
    ];
    wants = [
      "hindsight-healthcheck.service"
      "network-online.target"
    ];
    wantedBy = [ "multi-user.target" ];
    path = servicePath;
    environment = builtins.removeAttrs commonEnvironment [ "HERMES_MANAGED" ];
    serviceConfig = {
      Type = "simple";
      User = user;
      Group = user;
      WorkingDirectory = workspace;
      EnvironmentFile = [ config.sops.templates."hindsight-hermes.env".path ];
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f ${hermesHome}/.managed";
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
