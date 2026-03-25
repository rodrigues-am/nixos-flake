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
      openrouter_token = { };
      telegram_token = { };
      telegram_id = { };
      openai_key = { };
      firecrawl_token = { };
      # ... adicione outras se precisar referenciá-las individualmente
    };

    templates.".authinfo-amr" = {
      path = "/home/${userSettings.name}/sync/pessoal/security/.authinfo-amr";
      owner = "${userSettings.name}";
      content = ''
        machine openrouter.ai login apikey password ${config.sops.placeholder.openrouter_token}
        machine api.telegram.org login bot password ${config.sops.placeholder.telegram_token}
        machine api.openai.com login apikey password ${config.sops.placeholder.openai_key}
      '';
    };
  };
}
