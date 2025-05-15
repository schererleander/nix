{ config, lib, pkgs, ... }:

{
  options.foot.enable = lib.mkEnableOption "Enable and configure the Foot terminal emulator";
  config = lib.mkIf config.foot.enable {
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "SpaceMono" "IBMPlexMono" "Terminus" ]; })
    ];

    programs.foot = {
      enable = true;
      settings = {
        main = {
          pad = "10x10";
          font = "SpaceMono Nerd Font Mono:size=10";
          line-height = 12;
        };

        cursor = {
          style = "underline";
          unfocused-style = "unchanged";
          blink = true;
        };

        colors = {
          alpha = 0.9;
          # Gruvbox Theme
          background = "000000";
          foreground = "ebdbb2";

          regular0 = "282828";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "a89984";

          bright0 = "928374";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
        };
      };
    };
  };
}
