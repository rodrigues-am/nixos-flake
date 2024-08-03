{ config, lib, pkgs, userSettings, ... }: {

  services.syncthing = {
    enable = true;
    dataDir = "/home/andre/.local/share/syncthing";
    openDefaultPorts = true;
    configDir = "/home/andre/.config/syncthing";
    user = "${userSettings.name}";
    group = "users";
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;

    settings.devices = {
      "home-desktop" = {
        id = "SESEFI3-AKN5GKF-5U4YVBF-KGWPBYB-WRHFQ22-5DWW2SP-5VHJGBE-5WM3QQ6";
        autoAcceptFolders = true;
      };
      "s22-cel" = {
        id = "V5FI5LW-TSHJUIR-LVFYZHA-3CZX7WV-QMRI7AA-NPETMDZ-G67UE2G-5MGMVQ4";
        autoAcceptFolders = true;
      };
      "usp-desktop" = {
        id = "YAB3POW-GTB3WEC-OH4WJWA-VIG3DST-XFJVJ3Q-3HDYR66-RKAO7UI-FS32YAR";
        autoAcceptFolders = true;
      };
      "dell-laptop" = {
        id = "GUW2JMZ-TKHWHP2-S6F7IGP-3UKUXIA-CUWCGTV-Z42ACS7-5WWHKRS-5KEXIQP";
        autoAcceptFolders = true;
      };
      "hp-laptop" = {
        id = "AWARHUU-5XNZSLX-BUIQK7B-KR26TOW-UAMFEOB-HERNOQH-EJQCU5T-HQJ24AR";
        autoAcceptFolders = true;
      };
      "thinkpad" = {
        id = "SHARK5X-T43RLXJ-JYQIIU6-LKFOIT4-DVII6XM-XW4VKRJ-MYO77XU-QKBZUAF";
        autoAcceptFolders = true;
      };
    };

    settings.folders = {

      "sync" = {
        id = "default";
        path = "/home/andre/sync";
        devices =
          [ "home-desktop" "usp-desktop" "dell-laptop" "hp-laptop" "thinkpad" ];
        versioning = {
          type = "simple";
          params = { keep = "10"; };
        };
      };

      "notas" = {
        id = "tkpde-x2smc";
        path = "/home/andre/notas";
        devices = [
          "home-desktop"
          "usp-desktop"
          "dell-laptop"
          "s22-cel"
          "hp-laptop"
          "thinkpad"
        ];
        versioning = {
          type = "simple";
          params = { keep = "10"; };
        };
      };

      ".ssh" = {
        id = "vworj-qlkdr";
        path = "/home/andre/.ssh";
        devices = [
          "home-desktop"
          "usp-desktop"
          "dell-laptop"
          "s22-cel"
          "hp-laptop"
          "thinkpad"
        ];
        versioning = {
          type = "simple";
          params = { keep = "10"; };
        };
      };

    };

  };

}
