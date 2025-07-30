{ config, pkgs, lib, ... }:

let

  mailDir = "${config.home.homeDirectory}/.mail";
  gmailEmail = "rodrigues.am83@gmail.com";
  uspmailEmail = "rodrigues.am@usp.br";

  clientIdFile = config.sops.secrets.uspmail-client-id.path;
  clientSecretFile = config.sops.secrets.uspmail-client-secret.path;
  refreshTokenFile = config.sops.secrets.uspmail-refresh-token.path;

  oauth2-token-script = import ./bin/oauth2-token.nix {
    inherit pkgs clientIdFile clientSecretFile refreshTokenFile;
  };
  oauth2-token = "${oauth2-token-script.oauth2-token}/bin/oauth2-token";

in {
  home.packages = with pkgs; [ msmtp mu oauth2ms isync ];

  sops.secrets.uspmail-client-id = {
    sopsFile = ../secrets/secrets.yaml;
    key = "usp_client_id";
  };

  sops.secrets.uspmail-client-secret = {
    sopsFile = ../secrets/secrets.yaml;
    key = "usp_client_secret";
  };

  sops.secrets.uspmail-refresh-token = {
    sopsFile = ../secrets/secrets.yaml;
    key = "usp_refresh_token";
  };

  sops.secrets.gmail-password = {
    sopsFile = ../secrets/secrets.yaml;
    key = "gmail_key";
  };

  programs.msmtp = {
    enable = true;
    configContent = ''
      defaults
      auth           on
      tls            on
      tls_starttls   on
      logfile        ~/.msmtp.log

      account gmail
      host smtp.gmail.com
      port 587
      from ${gmailEmail}
      user ${gmailEmail}
      passwordeval cat ${config.sops.secrets.gmail-password.path}

      account uspmail
      auth oauthbearer
      host smtp.gmail.com
      port 587
      from ${uspmailEmail}
      user ${uspmailEmail}
      passwordeval "${oauth2-token}"

      account default : uspmail
    '';
  };

  home.file.".mbsyncrc".text = ''
            ##################
               ## Conta pessoal
               ##################

               IMAPAccount gmail
               Host imap.gmail.com
               Port 993
               User rodrigues.am83@gmail.com
               PassCmd "cat ${config.sops.secrets.gmail-password.path}"
    AuthMechs PLAIN LOGIN
               TLSType IMAPS
        CertificateFile /etc/ssl/certs/ca-certificates.crt

               IMAPStore gmail-remote
               Account gmail

               MaildirStore gmail-local
               Path  ${mailDir}/gmail/
               Inbox  ${mailDir}/gmail/Inbox

                Channel gmail-inbox
                Far :gmail-remote:
                Near :gmail-local:
               Patterns "INBOX" "[Gmail]/All Mail" "[Gmail]/Sent Mail" "[Gmail]/Drafts"
                Create Both
                Expunge Both
                SyncState *

               ##################
               ## Conta USPmail
               ##################
               IMAPAccount uspmail
               Host imap.gmail.com
               Port 993
               User ${uspmailEmail}
               AuthMechs XOAUTH2
               PassCmd "${oauth2-token}"
               TLSType IMAPS
               CertificateFile /etc/ssl/certs/ca-certificates.crt

               IMAPStore uspmail-remote
               Account uspmail

               MaildirStore uspmail-local
               Path ${mailDir}/uspmail/
               Inbox ${mailDir}/uspmail/Inbox

               Channel uspmail-inbox
               Far :uspmail-remote:
               Near :uspmail-local:
               Patterns "INBOX" "[Gmail]/All Mail" "[Gmail]/Sent Mail" "[Gmail]/Drafts"
               Create Both
               Expunge Both
               SyncState *
  '';

  systemd.user.services.mbsync-gmail = {
    Unit = { Description = "mbsync Gmail Service"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync gmail-inbox";
    };
  };

  systemd.user.timers.mbsync-gmail-timer = {
    Unit = { Description = "Run mbsync Gmail every 3 minutes"; };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "3min";
      Persistent = true;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  systemd.user.services.mbsync-uspmail = {
    Unit = { Description = "mbsync USPmail Service"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync uspmail-inbox";
    };
  };

  systemd.user.timers.mbsync-uspmail-timer = {
    Unit = { Description = "Run mbsync USPmail every 3 minutes"; };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "3min";
      Persistent = true;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  # Criação de diretórios Maildir
  home.activation.createMaildir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${mailDir}/gmail/Inbox
    chmod 700 ${mailDir}/gmail/Inbox

    mkdir -p ${mailDir}/uspmail/Inbox
    chmod 700 ${mailDir}/uspmail/Inbox
  '';
}
