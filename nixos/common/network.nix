{ config, ... }:
{
  networking = {
    hostName = "hermes-server";
    networkmanager.enable = true;
    firewall = {
      enable = true;
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
