{ ... }: {

  services.mcp-servers = {
    enable = true;
    clients.generateConfigs = true; # Habilita a geração de configurações MCP

    # Configure o servidor mcp-nixos
    servers.nixos = {
      enable = true;
      command = "uvx"; # Usa o padrão
      args = [ "mcp-nixos" ]; # Usa o padrão
    };

    # Configure para qual cliente (nesse caso, a configuração do mcp.el)
    clients.mcp-el = {
      enable = true;
      # Ajuste o 'configPath' se o mcp.el esperar um arquivo de configuração específico
      # configPath = "/caminho/para/config/do/mcp-el.json";
      servers = [ "nixos" ];
    };
  };
}
