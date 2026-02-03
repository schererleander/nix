{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.media.nixcord;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.nx.media.nixcord = {
    enable = mkEnableOption "nixcord and setup";
  };
  config = mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      config = {
        themeLinks = [
          "https://refact0r.github.io/system24/theme/system24.theme.css"
        ];
        frameless = true;
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