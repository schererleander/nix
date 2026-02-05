{
  flake.modules.nixos.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };
}
