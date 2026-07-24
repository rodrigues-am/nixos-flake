{ userSettings, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/.config/sops/age/keys.txt";

    secrets = {
      firecrawl_token = { };
      gmail_key = { };
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
