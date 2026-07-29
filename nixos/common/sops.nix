{ config, userSettings, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/sync/pessoal/security/sops/age/keys.txt";

    secrets = {
      firecrawl_token = { };
      gmail_key = { };
      hermes_api_server_key = {
        owner = userSettings.name;
        group = userSettings.name;
        mode = "0400";
      };
      ollama_key = { };
      openai_key = { };
      openrouter_token_hermes = { };
      telegram_id = { };
      telegram_token = { };
      usp_client_id = { };
      usp_client_secret = { };
      usp_refresh_token = { };
      webdav_key = { };
    };

    templates."hermes-api-server.env" = {
      owner = userSettings.name;
      group = userSettings.name;
      mode = "0400";
      content = ''
        API_SERVER_KEY=${config.sops.placeholder.hermes_api_server_key}
      '';
    };
  };
}
