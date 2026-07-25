_: {
  services.logind.settings.Login = {
    # O Dell atua como servidor headless e deve continuar funcionando com a
    # tampa fechada, tanto na tomada quanto fora dela ou em dock.
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
