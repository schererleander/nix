{
  flake.modules.homeManager.wine =
    { pkgs, ... }:
    let
      wine = pkgs.wineWow64Packages.stagingFull;

      winetricksFixed = pkgs.writeShellScriptBin "winetricks" ''
        export WINE="${wine}/bin/wine"
        export WINESERVER="${wine}/bin/wineserver"

        # Winetricks architecture detection must inspect the real ELF
        # binaries rather than Nixpkgs' Wine wrapper.
        export WINE_BIN="${wine}/bin/.wine"
        export WINESERVER_BIN="${wine}/bin/wineserver"

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
