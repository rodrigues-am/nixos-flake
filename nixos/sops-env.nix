{
  config,
  userSettings,
  ...
}:
{

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.name}/.config/sops/age/keys.txt";

    secrets = {

      gmail_key = { };
      usp_client_id = { };
      usp_client_secret = { };
      usp_refresh_token = { };
      openrouter_token_hermes = { };
      openrouter_token_emacs = { };
      telegram_token = { };
      telegram_id = { };
      falia_token = { };
      firecrawl_token = { };
      openai_key = { };
      webdav_key = { };
      ifusp_key = { };

    };

    templates.".authinfo-amr" = {
      path = "/home/${userSettings.name}/sync/pessoal/security/.authinfo-amr";
      owner = "${userSettings.name}";
      content = ''
        machine openrouter.ai login hermes_key password ${config.sops.placeholder.openrouter_token_hermes}
        machine openrouter.ai login emacs_key password ${config.sops.placeholder.openrouter_token_emacs}
        machine api.telegram.org login bot password ${config.sops.placeholder.telegram_token}
        machine api.openai.com login apikey password ${config.sops.placeholder.openai_key}
      '';
    };
  };
}
