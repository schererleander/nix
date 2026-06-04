{
  flake.modules.homeManager.wine =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        q4wine
        winetricks
        unzip
        cabextract
        wineWow64Packages.waylandFull
      ];
      home.sessionVariables = {
        WINEARCH = "win64";
        WINEPREFIX = "$HOME/.wine";
      };
    };
}
