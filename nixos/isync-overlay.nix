{ ... }:

let
  xoauth2Overlay = final: prev: {
    isync = prev.isync.override { withCyrusSaslXoauth2 = true; };
  };
in { nixpkgs.overlays = [ xoauth2Overlay ]; }
