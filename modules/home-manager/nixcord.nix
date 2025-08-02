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
      #discord.enable = false;
      #vesktop.enable = true;
      #quickCss = "some CSS";  # quickCSS file
      config = {
        #useQuickCss = true;   # use our quickCSS
        themeLinks = [
          # or use an online theme
          "https://refact0r.github.io/system24/theme/system24.theme.css"
        ];
        frameless = true; # set some Vencord options
        plugins = {
          alwaysAnimate.enable = false;
          hideAttachments.enable = true;
          imageLink.enable = true;
          imageZoom.enable = true;
          translate.enable = true;
        };
      };
    };
  };
}
