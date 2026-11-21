{
  flake.modules.homeManager.jellyfin-desktop =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.jellyfin-desktop.overrideAttrs (
          finalAttrs: _: {
            version = "2.1.0-pre2";
            src = pkgs.fetchFromGitHub {
              owner = "jellyfin";
              repo = "jellyfin-desktop";
              tag = "v${finalAttrs.version}";
              fetchSubmodules = true;
              hash = "sha256-yBp9C0y2r8jbkV43Wxph4obJPst6033NAJ2H82cax58=";
            };
          }
        ))
      ];
    };
}
