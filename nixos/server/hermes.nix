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
    python3
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
    environmentFiles = [ config.sops.secrets.hermes_env_default.path ];
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
      python3
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

  # O Secretario usa bot e porta de API próprios, mas compartilha o estado
  # base para continuar sendo um perfil Hermes normal.
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
      EnvironmentFile = config.sops.secrets.hermes_env_secretario.path;
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
      EnvironmentFile = config.sops.secrets.hermes_env_default.path;
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
