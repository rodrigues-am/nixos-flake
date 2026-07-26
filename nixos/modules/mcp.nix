{ pkgs, ... }: {

  services.searx = { package = pkgs.searxng; };
}
