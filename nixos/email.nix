{ config, pkgs, ... }:

let
  mailDir = "/home/andre/Mail";
  account = "gmail";
  email = "rodrigues.am83@gmail.com";

in {
  sops.secrets.gmail-password = {
    sopsFile = ../secrets/secrets.yaml;
    key = "gmail_key";
    owner = "andre";
  };

  # msmtp é declarativo
  programs.msmtp = {
    enable = true;
    accounts.${account} = {
      auth = true;
      from = email;
      host = "smtp.gmail.com";
      port = 587;
      user = email;
      tls = true;
      tls_starttls = true;
      passwordeval = "cat ${config.sops.secrets.gmail-password.path}";
    };
  };

  # Cria os diretórios de Maildir no boot
  systemd.tmpfiles.rules =
    [ "d ${mailDir}/${account}/Inbox 0700 andre users - -" ];

  environment.systemPackages = with pkgs; [ mu isync ];
}
