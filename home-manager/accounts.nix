{ config, lib, pkgs, userSettings, nix-doom-emacs, nix-colors, ... }:

{

  accounts.email = {
    accounts.gmail = {
      address = "rodrigues.am83@gmail.com";
      realName = "Andre Rodrigues";
      userName = "rodrigues.am83@gmail.com";
      passwordCommand = "cat ~/sync/pessoal/security/psw-email-1";
      primary = true;
      # gpg = {
      #   key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
      #   signByDefault = true;
      # };
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.useStartTls = true;
      };
      smtp = {
        host = "stmp.gmail.com";
        port = 465;
        tls.useStartTls = true;
      };
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
      msmtp.enable = true;
      mu.enable = true;
      thunderbird.enable = true;
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
    };

    accounts.usp = {
      address = "rodrigues.am@usp.br";
      userName = "rodrigues.am@ups.br";
      realName = "Andre Rodrigues";
      passwordCommand = "cat ~/sync/pessoal/security/psw-email-1";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.useStartTls = true;
      };
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
      msmtp.enable = true;
      mu.enable = true;
      thunderbird = { enable = true; };
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
      smtp = {
        host = "stmp.gmail.com";
        port = 465;
        tls.useStartTls = true;
      };
    };

  };

}
