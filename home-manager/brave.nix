{ config, lib, pkgs, ...}:

{
  programs.brave = {
        enable = true;
        
        extensions = [ 
          "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
          "ldipcbpaocekfooobnbcddclnhejkcpn" # google scholar
          "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
        ];
  };
}
