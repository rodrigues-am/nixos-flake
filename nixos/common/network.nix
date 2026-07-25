{ config, ... }: {
  networking = {
    hostName = "hermes-server";
    networkmanager = {
      enable = true;
      # O DNS do roteador (192.168.15.1) devolve respostas EDNS malformadas
      # para registry.npmjs.org, bloqueando os fetchers do Hermes Agent.
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    firewall = {
      enable = true;
      # Bootstrap: manter SSH acessível pela LAN enquanto o Tailscale é ativado.
      # Remover esta porta após validar acesso pela Tailnet e instalar as chaves.
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        PermitRootLogin = "no";
        MaxAuthTries = 3;
        LoginGraceTime = 30;
      };
    };
    tailscale.enable = true;
  };
}
