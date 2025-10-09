{ pkgs, config, ... }: {

  services.matrix-synapse = {
    enable = true;
    serverName = "localhost"; # Pode ser localhost se for só para uso interno
    registrationSharedSecret = "andre";
  };

  # Importando secrets do sops
  sops.secrets.mautrix-whatsapp-shared_secret = { };
  sops.secrets.mautrix-whatsapp-as_token = { };
  sops.secrets.mautrix-whatsapp-hs_token = { };

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = config.sops.secrets.mautrix-whatsapp-shared_secret.path;
    settings = {
      homeserver = {
        address = "http://localhost:8008";
        domain = "localhost";
      };
      appservice = {
        address = "http://localhost:29318";
        as_token =
          builtins.readFile config.sops.secrets.mautrix-whatsapp-as_token.path;
        hs_token =
          builtins.readFile config.sops.secrets.mautrix-whatsapp-hs_token.path;
        id = "whatsapp";
        namespaces.users = [{
          exclusive = true;
          regex = "@whatsapp_.*:localhost";
        }];
      };
      bridge = {
        login_shared_secret_map = {
          "localhost" = builtins.readFile
            config.sops.secrets.mautrix-whatsapp-shared_secret.path;
        };
      };
    };
  };

}
