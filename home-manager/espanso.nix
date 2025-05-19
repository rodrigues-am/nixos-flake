{ ... }:

{
  home.file = {
    ".config/espanso/match/base.yml".source = ./espanso/match/base.yml;
  };

  services.espanso = {
    enable = true;
    configs = {
      default = {
        disable_x11_fast_inject = true;
        backend = "inject";
      };
    };
  };
}
