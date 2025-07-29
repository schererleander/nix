{
  config,
  lib,
  ...
}:

{
  options.waybar.enable = lib.mkEnableOption "Enable and configure Waybar";
  config = lib.mkIf config.waybar.enable {

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 15;
          layer = "top";
          position = "bottom";
          modules-center = [ ];
          modules-left = [ "sway/workspaces" ];
          modules-right = [
            "tray"
            "privacy"
            "battery"
            "pulseaudio"
            "network"
            "bluetooth"
            "clock"
          ];

          tray = {
            spacing = 10;
          };

          privacy = {
            icon-size = 16;
          };

          network = {
            format-disconnect = "";
            format-ethernet = "";
            format-wifi = "{icon} {signalStrength}";
            format-icon = [
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            tooltip-format-wifi = "{essid}";
            tooltip-format-ethernet = "{ifname}";
          };

          bluetooth = {
            format = " {status}";
            format-disabled = "";
            format-no-controller = "";
            format-connected = " {device_alias}";
            tooltip = false;
          };

          clock = {
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-bluetooth = "{volume}% {icon}";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
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
          background: rgba(0, 0, 0, 0.9);
        }

        #workspaces button {
          padding-left: 5px;
          padding-right: 5px;
        }

        #workspaces button.focused {
          font-weight: bold;
        }

        #clock, #pulseaudio, #tray, #network, battery, bluetooth {
          padding-left: 5px;
          padding-right: 5px;
        }
      '';
    };
  };
}
