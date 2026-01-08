{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nx.steam;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.steam = {
    enable = mkOption {
      description = "Digital distribution platfrom from vavle";
      type = types.bool;
      default = false;
    };
    useProtontricks = mkOption {
      description = "Whether to enable protontricks";
      type = types.bool;
      default = true;
    };
    useGamescope = mkOption {
      description = "SteamOS session compositing window manager";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = cfg.useProtontricks;
      gamescopeSession.enable = cfg.useGamescope;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
