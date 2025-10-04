{
  config,
  lib,
  ...
}:

{
  options.nixcord.enable = lib.mkEnableOption "Enable nixcord and setup";
  config = lib.mkIf config.nixcord.enable {
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
