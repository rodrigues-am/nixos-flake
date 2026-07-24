{ lib, ... }:
{
  imports = [ ../syncthing.nix ];

  # No servidor, conexões Syncthing entram pela interface Tailscale confiável;
  # as portas não devem ser abertas nas demais interfaces.
  services.syncthing.openDefaultPorts = lib.mkForce false;
}
