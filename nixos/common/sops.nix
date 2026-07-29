{ userSettings, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/sync/pessoal/security/sops/age/keys.txt";

    secrets = {
      firecrawl_token = { };
      gmail_key = { };
      hermes_env_default = {
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
  };
}
