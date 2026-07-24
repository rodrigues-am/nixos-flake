_: {
  programs.bash.shellAliases = {
    amr-nixos-hermes-server = "sudo nixos-rebuild switch --flake /home/andre/nixos-flake#hermes-server";
    rebuild = "sudo nixos-rebuild switch --flake /home/andre/nixos-flake#hermes-server";
  };
}
