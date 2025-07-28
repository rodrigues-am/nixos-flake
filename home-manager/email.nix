{ config, pkgs, lib, ... }:

let
  mailDir = "${config.home.homeDirectory}/Mail";
  account = "gmail";
  email = "rodrigues.am83@gmail.com";
in {
  home.packages = with pkgs; [ msmtp mu isync ];

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
      from ${email}
      user ${email}
      passwordeval cat ${config.sops.secrets.gmail-password.path}

      account default : gmail
    '';
  };

  home.file.".mbsyncrc".text = ''
    IMAPAccount gmail
    Host imap.gmail.com
    Port 993
    User rodrigues.am83@gmail.com
    PassCmd "cat ${config.sops.secrets.gmail-password.path}"
    TLSType IMAPS

    IMAPStore gmail-remote
    Account gmail

    MaildirStore gmail-local
    Path ~/Mail/gmail/
    Inbox ~/Mail/gmail/Inbox

    Channel gmail-inbox
    Far :gmail-remote:
    Near :gmail-local:
    Patterns "INBOX"
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

  home.activation.createMaildir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${mailDir}/${account}/Inbox
    chmod 700 ${mailDir}/${account}/Inbox
  '';
}
