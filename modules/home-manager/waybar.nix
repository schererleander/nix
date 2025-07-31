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
          height = 32;
          layer = "top";
          position = "bottom";
          modules-center = [ ];
          modules-left = [ "sway/workspaces" ];
          modules-right = [
            "group/expand"
            "battery"
            "pulseaudio"
            "network"
            "bluetooth"
            "clock"
          ];

          "group/expand" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 600;
              transition-to-left = true;
              click-to-reveal = true;
            };
            modules = [
              "custom/expand"
              "tray"
              "privacy"
              "cpu"
              "memory"
              "temperature"
            ];
          };

          "custom/expand" = {
            format = "";
            tooltip = false;
          };

          tray = {
            spacing = 10;
          };

          privacy = {
            icon-size = 16;
          };

          cpu = {
            format = "󰻠";
            tooltip = true;
          };

          memory = {
            format = "";
          };

          temperature = {
            critical-threshold = 80;
            format = "";
          };

          network = {
            format-disconnect = "󰌙";
            format-ethernet = "󰌘";
            format-wifi = "{icon}";
            format-icons = [
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];

            tooltip-format-wifi = "{essid} | {signalStrength}%";
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
            format = "{icon}";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
						tooltip-format = "{desc} | {volume}%";
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

        #clock, #pulseaudio, #tray, #network, #battery, #bluetooth, #cpu, #memory, #temperature, #custom-expand, #group-expand {
          padding-left: 10px;
          padding-right: 10px;
        }
      '';
    };
  };
}
