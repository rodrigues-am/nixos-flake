{ config, lib, pkgs, userSettings, nix-doom-emacs, nix-colors, ... }:

{

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles."${userSettings.name}-pessoal" = { isDefault = true; };
    profiles."${userSettings.name}-usp" = { isDefault = false; };
  };

  accounts.email = {
    accounts.gmail = {
      address = "rodrigues.am83@gmail.com";
      # gpg = {
      #   key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
      #   signByDefault = true;
      # };
      imap = {
        host = "gmail.com";
        port = 143;
        tls.useStartTls = true;
      };
      mbsync = {
        enable = true;
        #frequency = "*:0/5";
        create = "both";
        expunge = "both";
      };
      msmtp.enable = true;
      mu.enable = true;
      thunderbird = {
        enable = true;
        profiles =
          [ "${userSettings.name}-pessoal" "${userSettings.name}-usp" ];
      };
      primary = true;
      realName = "Andre Rodrigues";
      signature = {
        text = ''
          Prof. Dr. André Machado Rodrigues
          Departamento de Física Aplicada
          Instituto de Física - Universidade de São Paulo
          Telefone: +55 (11) 3091-7108
          Sala: 3016 - Prédio Ala II
        '';
        showSignature = "append";
      };
      passwordCommand = "mail-password";
      smtp = {
        host = "stmp.gmail.com";
        port = 587;
        tls.useStartTls = true;
      };
      userName = "rodrigues.am83@gmail.com";
    };

    accounts.usp = {
      address = "rodrigues.am@usp.br";
      # gpg = {
      #   key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
      #   signByDefault = true;
      # };
      imap = {
        host = "imap.gmail.com";
        port = 143;
        tls.useStartTls = true;
      };
      mbsync = {
        enable = true;
        #frequency = "*:0/5";
        create = "both";
        expunge = "both";
      };
      msmtp.enable = true;
      mu.enable = true;
      thunderbird = {
        enable = true;
        profiles = [ "${userSettings.name}-usp" ];
      };
      realName = "Andre Rodrigues";
      signature = {
        text = ''
          Prof. Dr. André Machado Rodrigues
          Departamento de Física Aplicada
          Instituto de Física - Universidade de São Paulo
          Telefone: +55 (11) 3091-7108
          Sala: 3016 - Prédio Ala II
        '';
        showSignature = "append";
      };
      passwordCommand = "mail-password";
      smtp = {
        host = "stmp.gmail.com";
        port = 587;
        tls.useStartTls = true;
      };
      userName = "rodrigues.am@ups.br";
    };

  };

}
