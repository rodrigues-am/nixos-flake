{ ... }: {
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };
  # Configure console keymap
  console.keyMap = "us-acentos";
}
