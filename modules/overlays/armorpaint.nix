{
  flake.overlays.armorpaint = final: _prev: {
    armorpaint = final.callPackage ../../packages/armorpaint.nix { };
  };
}
