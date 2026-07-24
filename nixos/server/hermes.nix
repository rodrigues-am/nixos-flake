{
  config,
  pkgs,
  userSettings,
  ...
}:
{
  sops.templates."hermes.env" = {
    owner = userSettings.name;
    group = "users";
    mode = "0400";
    content = ''
      OPENROUTER_API_KEY=${config.sops.placeholder.openrouter_token_hermes}
      OPENAI_API_KEY=${config.sops.placeholder.openai_key}
      OLLAMA_API_KEY=${config.sops.placeholder.ollama_key}
      FIRECRAWL_API_KEY=${config.sops.placeholder.firecrawl_token}
      TELEGRAM_BOT_TOKEN=${config.sops.placeholder.telegram_token}
      ALLOWED_TELEGRAM_IDS=${config.sops.placeholder.telegram_id}
    '';
  };

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    user = userSettings.name;
    group = userSettings.name;
    createUser = false;

    # O módulo acrescenta /.hermes ao stateDir; assim HERMES_HOME fica
    # exatamente em /home/andre/.hermes, conforme escolhido.
    stateDir = "/home/${userSettings.name}";
    workingDirectory = "/home/${userSettings.name}";
    environmentFiles = [ config.sops.templates."hermes.env".path ];
    extraDependencyGroups = [ "messaging" ];

    extraPackages = with pkgs; [
      age
      bash
      curl
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

    settings = {
      model = {
        provider = "ollama-cloud";
        default = "glm-5.2";
      };
      toolsets = [ "all" ];
      agent.max_turns = 150;
      terminal = {
        backend = "local";
        cwd = "/home/${userSettings.name}";
        timeout = 180;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };

    restart = "always";
    restartSec = 5;
  };
}
