{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.nixcord;
in {
  options.nixcord.enable = lib.mkEnableOption "Enable nixcord and setup";
  config = lib.mkIf cfg.enable {
    programs.nixcord = {
      enable = true;  # enable Nixcord. Also installs discord package
      #quickCss = "some CSS";  # quickCSS file
      config = {
        #useQuickCss = true;   # use our quickCSS
        #themeLinks = [        # or use an online theme
        #  "https://raw.githubusercontent.com/link/to/some/theme.css"
        #];
        frameless = true; # set some Vencord options
        plugins = {
          hideAttachments.enable = true;    # Enable a Vencord plugin
          ignoreActivities = {    # Enable a plugin and set some options
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
        };
      };
    };
  };
}