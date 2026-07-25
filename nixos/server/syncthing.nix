{ lib, ... }:
{
  imports = [ ../syncthing.nix ];

  services.syncthing = {
    # No servidor, conexões Syncthing entram pela interface Tailscale confiável;
    # as portas não devem ser abertas nas demais interfaces.
    openDefaultPorts = lib.mkForce false;

    # O servidor deve manter apenas as duas pastas declaradas abaixo. Isso
    # também remove pastas autoaceitas anteriormente, como /home/andre/.ssh.
    overrideDevices = lib.mkForce true;
    overrideFolders = lib.mkForce true;

    settings = {
      devices = lib.mkForce {
        "home-desktop" = {
          id = "SESEFI3-AKN5GKF-5U4YVBF-KGWPBYB-WRHFQ22-5DWW2SP-5VHJGBE-5WM3QQ6";
          autoAcceptFolders = false;
        };
        "s22-cel" = {
          id = "V5FI5LW-TSHJUIR-LVFYZHA-3CZX7WV-QMRI7AA-NPETMDZ-G67UE2G-5MGMVQ4";
          autoAcceptFolders = false;
        };
        "hp-laptop" = {
          id = "AWARHUU-5XNZSLX-BUIQK7B-KR26TOW-UAMFEOB-HERNOQH-EJQCU5T-HQJ24AR";
          autoAcceptFolders = false;
        };
        thinkpad = {
          id = "SHARK5X-T43RLXJ-JYQIIU6-LKFOIT4-DVII6XM-XW4VKRJ-MYO77XU-QKBZUAF";
          autoAcceptFolders = false;
        };
        boox = {
          id = "NEKJLFN-X3D5WTA-UVJU3J5-INB2WJW-ATANUIB-Z54M63N-2NGPCVG-3ECIKA2";
          autoAcceptFolders = false;
        };

      };

      folders = {
        sync = {
          id = "default";
          path = lib.mkForce "/home/andre/sync";
          devices = lib.mkForce [
            "home-desktop"
            "hp-laptop"
            "thinkpad"
          ];
        };

        notas = {
          id = "tkpde-x2smc";
          path = lib.mkForce "/home/andre/notas";
          devices = lib.mkForce [
            "home-desktop"
            "s22-cel"
            "hp-laptop"
            "thinkpad"
            "boox"
          ];
        };
      };
    };
  };
}
