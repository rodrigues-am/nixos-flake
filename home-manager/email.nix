{
  config,
  pkgs,
  lib,
  ...
}:

let

  mailDir = "${config.home.homeDirectory}/.mail";
  gmailEmail = "rodrigues.am83@gmail.com";
  uspmailEmail = "rodrigues.am@usp.br";

  clientIdFile = config.sops.secrets.uspmail-client-id.path;
  clientSecretFile = config.sops.secrets.uspmail-client-secret.path;
  refreshTokenFile = config.sops.secrets.uspmail-refresh-token.path;

  oauth2-token-set = import ./bin/oauth2-token.nix {
    inherit
      pkgs
      clientIdFile
      clientSecretFile
      refreshTokenFile
      ;
  };
  oauth2-token-bin = "${oauth2-token-set.oauth2-token}/bin/oauth2-token";

in
{
  home.packages = with pkgs; [
    msmtp
    mu
    isync
    oauth2-token-set.oauth2-token
  ];

  # ── Secrets (sops-nix) ──────────────────────────────────────────────
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

  # ── msmtp (envio) ───────────────────────────────────────────────────
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
      passwordeval "${oauth2-token-bin}"

      account default : uspmail
    '';
  };

  # ── mbsync (.mbsyncrc) ──────────────────────────────────────────────
  home.file.".mbsyncrc".text = ''
    #####################
    ## Conta Gmail (pessoal)
    #####################
    IMAPAccount gmail
    Host imap.gmail.com
    Port 993
    User ${gmailEmail}
    PassCmd "cat ${config.sops.secrets.gmail-password.path}"
    AuthMechs PLAIN LOGIN
    TLSType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt

    IMAPStore gmail-remote
    Account gmail

    MaildirStore gmail-local
    Path ${mailDir}/gmail/
    Inbox ${mailDir}/gmail/INBOX
    SubFolders Legacy

    Channel gmail
    Far :gmail-remote:
    Near :gmail-local:
    Patterns "INBOX" "[Gmail]/Sent Mail" "[Gmail]/Drafts" "[Gmail]/Trash" "[Gmail]/All Mail"
    Create Both
    Expunge Both
    SyncState *

    #####################
    ## Conta USPmail
    #####################
    IMAPAccount uspmail
    Host imap.gmail.com
    Port 993
    User ${uspmailEmail}
    AuthMechs XOAUTH2
    PassCmd "${oauth2-token-bin}"
    TLSType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt

    IMAPStore uspmail-remote
    Account uspmail

    MaildirStore uspmail-local
    Path ${mailDir}/uspmail/
    Inbox ${mailDir}/uspmail/INBOX
    SubFolders Legacy

    Channel uspmail
    Far :uspmail-remote:
    Near :uspmail-local:
    Patterns "INBOX" "[Gmail]/Sent Mail" "[Gmail]/Drafts" "[Gmail]/Trash" "[Gmail]/All Mail"
    Create Both
    Expunge Both
    SyncState *
  '';

  # ── Systemd timers (sync a cada 3 min) ──────────────────────────────
  systemd.user.services.mbsync-gmail = {
    Unit = {
      Description = "mbsync Gmail Service";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync gmail";
    };
  };

  systemd.user.timers.mbsync-gmail-timer = {
    Unit = {
      Description = "Run mbsync Gmail every 3 minutes";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "3min";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services.mbsync-uspmail = {
    Unit = {
      Description = "mbsync USPmail Service";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync uspmail";
    };
  };

  systemd.user.timers.mbsync-uspmail-timer = {
    Unit = {
      Description = "Run mbsync USPmail every 3 minutes";
    };
    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "3min";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # ── Criação estrutura Maildir completa ───────────────────────────────
  # SubFolders Legacy cria subpastas como .[Gmail].Sent Mail automaticamente
  # mas garantimos o INBOX inicial para o mbsync não falhar na primeira run
  home.activation.createMaildir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${mailDir}/gmail/INBOX/{cur,new,tmp}
    chmod 700 ${mailDir}/gmail/INBOX

    mkdir -p ${mailDir}/uspmail/INBOX/{cur,new,tmp}
    chmod 700 ${mailDir}/uspmail/INBOX
  '';
}
