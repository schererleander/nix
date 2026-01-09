{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.media.nixcord;
  inherit (lib) mkEnableOption mkOption types mkIf;
in
{
  options.nx.media.nixcord = {
    enable = mkEnableOption "nixcord and setup";
    frameless = mkOption {
      description = "Make discord frameless";
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      config = {
        themeLinks = [
          "https://refact0r.github.io/system24/theme/system24.theme.css"
        ];
        frameless = cfg.frameless;
        plugins = {
          alwaysAnimate.enable = false;
          imageLink.enable = true;
          imageZoom.enable = true;
          translate.enable = true;
        };
      };
    };
  };
}
