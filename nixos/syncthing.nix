{
  lib,
  machineName,
  userSettings,
  ...
}:

let
  homeDir = "/home/${userSettings.name}";

  nixManagedDevices = [
    "home-desktop"
    "hermes-server"
    "hp-laptop"
    "thinkpad"
  ];

  allDevices = {
    "home-desktop" = {
      id = "SESEFI3-AKN5GKF-5U4YVBF-KGWPBYB-WRHFQ22-5DWW2SP-5VHJGBE-5WM3QQ6";
      autoAcceptFolders = false;
    };
    "s22-cel" = {
      id = "V5FI5LW-TSHJUIR-LVFYZHA-3CZX7WV-QMRI7AA-NPETMDZ-G67UE2G-5MGMVQ4";
      autoAcceptFolders = false;
    };
    "hermes-server" = {
      id = "GUW2JMZ-TKHWHP2-S6F7IGP-3UKUXIA-CUWCGTV-Z42ACS7-5WWHKRS-5KEXIQP";
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

  folderMembers = {
    sync = [
      "home-desktop"
      "hermes-server"
      "hp-laptop"
      "thinkpad"
    ];
    notas = [
      "home-desktop"
      "hermes-server"
      "s22-cel"
      "hp-laptop"
      "thinkpad"
      "boox"
    ];
  };

  peersFor = members: builtins.filter (device: device != machineName) members;
in
{
  assertions = [
    {
      assertion = builtins.elem machineName nixManagedDevices;
      message = "Unknown Syncthing machineName: ${machineName}";
    }
  ];

  services.syncthing = {
    enable = true;
    user = userSettings.name;
    group = "users";
    dataDir = "${homeDir}/.local/share/syncthing";
    configDir = "${homeDir}/.config/syncthing";
    guiAddress = "127.0.0.1:8384";

    # O servidor só recebe conexões pela rede confiável do Tailscale.
    openDefaultPorts = machineName != "hermes-server";

    # A configuração Nix é a fonte de verdade em todas as máquinas NixOS.
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      # Um nó Syncthing nunca deve declarar a si próprio como dispositivo remoto.
      devices = lib.removeAttrs allDevices [ machineName ];

      folders = {
        sync = {
          id = "default";
          path = "${homeDir}/sync";
          devices = peersFor folderMembers.sync;
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };

        notas = {
          id = "tkpde-x2smc";
          path = "${homeDir}/notas";
          devices = peersFor folderMembers.notas;
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
    };
  };
}
