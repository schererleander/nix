{
  flake.modules.homeManager.wine =
    { pkgs, config, ... }:
    let
      wine = pkgs.wineWow64Packages.waylandFull;

      wineForWinetricks = pkgs.runCommand "wine-for-winetricks" { } ''
        mkdir -p $out/bin

        ln -s ${wine}/bin/wine $out/bin/wine
        ln -s ${wine}/bin/wine $out/bin/wine64
        ln -s ${wine}/bin/wineserver $out/bin/wineserver
      '';

      winetricksFixed = pkgs.writeShellScriptBin "winetricks" ''
        export WINE="${wineForWinetricks}/bin/wine"
        export WINELOADER="${wineForWinetricks}/bin/wine"
        export WINESERVER="${wineForWinetricks}/bin/wineserver"

        # NixOS WoW64 wrapper fix.
        export WINE_BIN="${wine}/bin/.wine"
        export WINESERVER_BIN="${wine}/bin/wineserver"

        export WINEPREFIX="${config.home.homeDirectory}/.wine"
        export PATH="${wineForWinetricks}/bin:$PATH"

        exec ${pkgs.winetricks}/bin/winetricks "$@"
      '';

      q4wineFixed = pkgs.q4wine.override {
        inherit wine;
      };
    in
    {
      home.packages = [
        wine
        q4wineFixed
        winetricksFixed
        pkgs.unzip
        pkgs.cabextract
      ];
    };
}
