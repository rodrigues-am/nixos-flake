{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    settings.shared_preload_libraries = "timescaledb";
    extensions =
      ps: with ps; [
        age
        pgvector
        timescaledb
      ];
  };

  environment.systemPackages = [ pkgs.postgresql ];
}
