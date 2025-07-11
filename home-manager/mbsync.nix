{ pkgs, config, ... }: {
  sops.secrets.gmail-password = {
    sopsFile = ../secrets/secrets.yaml;
    key = "gmail_key";
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
}
