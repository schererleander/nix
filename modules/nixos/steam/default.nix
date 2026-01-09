{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.steam;
in
{
  options.nx.steam = {
    enable = mkEnableOption "Steam gaming platform";
    protontricks = mkEnableOption "protontricks" // {
      default = true;
    };
    gamescope = mkEnableOption "gamescope session compositor";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = cfg.protontricks;
      gamescopeSession.enable = cfg.gamescope;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
