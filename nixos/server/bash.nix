_: {
  programs = {
    bash.shellAliases = {
      amr-nixos-hermes-server = "sudo nixos-rebuild switch --flake /home/andre/nixos-flake#hermes-server";
      rebuild = "sudo nixos-rebuild switch --flake /home/andre/nixos-flake#hermes-server";
      via-off = "sudo /usr/local/bin/aruba-via-stop";
      via-on = "sudo /usr/local/bin/aruba-via-connect";
      via-status = "sudo /usr/local/bin/via-cli vpn status";
    };

    starship.enable = true;
  };
}
