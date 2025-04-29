{ config, lib, pkgs, ... }:

let
  cfg = config.waybar;
in {
  options.waybar.enable = lib.mkEnableOption "Enable and configure Waybar";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 20;
          layer = "top";
          position = "bottom";
          tray = { spacing = 10; };
          modules-center = [ "sway/window" ];
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-right = [
            "pulseaudio"
            "clock"
            "tray"
          ];
          clock = {
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              handsfree = "";
              headphones = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            on-click = "pavucontrol";
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: monospace;
          font-size: 12px;
        }

        window#waybar {
          background: #000000;
        }

        #workspaces button {
          padding-left: 5px;
          padding-right: 5px;
        }

        #clock, #pulseaudio, #tray {
          padding-left: 5px;
          padding-right: 5px;
        }
      '';
    };
  };
}
