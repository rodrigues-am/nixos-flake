_: {
  imports = [
    ../common/base.nix
    ../common/network.nix
    ../common/sops.nix
    ./bash.nix
    ./hermes.nix
    ./postgresql.nix
    ./power.nix
    ../syncthing.nix
    ./via.nix
    ./webdav.nix
  ];
}
