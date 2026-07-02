{ ... }:
{
  flake.overlays.rpcs3 = final: prev: {
    rpcs3 = (prev.rpcs3.override {
      glew = prev.glew.override { enableEGL = false; };
    }).overrideAttrs (old: {
      cmakeFlags = old.cmakeFlags or [] ++ [
        (prev.lib.cmakeBool "BUILD_SHARED_LIBS" false)
      ];
    });
  };
}
