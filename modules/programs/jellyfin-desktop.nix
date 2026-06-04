{
  flake.modules.homeManager.jellyfin-desktop =
    { pkgs, ... }:

    # Fix no video https://github.com/nixos/nixpkgs/issues/519073
    let
      jellyfin-desktop-gbm-off = pkgs.symlinkJoin {
        name = "jellyfin-desktop-gbm-off";
        paths = [ pkgs.jellyfin-desktop ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/jellyfin-desktop \
            --set QTWEBENGINE_FORCE_USE_GBM 0
        '';
      };
    in
    {
      home.packages = [
        jellyfin-desktop-gbm-off
      ];
    };
}
