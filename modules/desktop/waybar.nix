{
  config,
  lib,
  username,
  ...
}:

{
  options.nx.desktop.waybar.enable = lib.mkEnableOption "Enable and configure Waybar";
  config = lib.mkIf config.nx.desktop.waybar.enable {
    home-manager.users."${username}" = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            height = 32;
            layer = "top";
            position = "bottom";
            modules-center = [ "mpris" ];
            modules-left = [ "sway/workspaces" ];
            modules-right = [
              "privacy"
              "tray"
              "battery"
              "pulseaudio"
              "network"
              "bluetooth"
              "clock"
            ];

            mpris = {
              format = "{title}";
              tooltip-format = "{artist} - {album}";
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
          					background: none;
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
  };
}
