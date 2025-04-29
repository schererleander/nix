{ config, lib, pkgs, ... }:

let
  cfg = config.foot;
in {
  options.foot.enable = lib.mkEnableOption "Enable and configure the Foot terminal emulator";

  config = lib.mkIf cfg.enable {
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

        colors = {
          background = "000000";
          foreground = "f8f8f6";

          regular0 = "232a2d";
          regular1 = "e57474";
          regular2 = "8ccf7e";
          regular3 = "e5c76b";
          regular4 = "67b0e8";
          regular5 = "c47fd5";
          regular6 = "6cbfbf";
          regular7 = "b3b9b8";

          bright0  = "2d3437";
          bright1  = "ef7e7e";
          bright2  = "96d988";
          bright3  = "f4d67a";
          bright4  = "71baf2";
          bright5  = "ce89df";
          bright6  = "67cbe7";
          bright7  = "bdc3c2";
        };
      };
    };
  };
}

