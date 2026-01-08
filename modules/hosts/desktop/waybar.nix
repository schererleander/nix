{
  config,
  lib,
  username,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.waybar;
in
{
  options.nx.desktop.waybar.enable = mkEnableOption "Enable and configure Waybar";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            height = 32;
            layer = "top";
            position = "bottom";
            modules-center = [ "mpris" ];
            modules-left = [ "wlr/workspaces" ];
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
              format = " {status}";
              format-disabled = "";
              format-no-controller = "";
              format-connected = " {device_alias}";
            };

            clock = {
              format-alt = "{:%Y-%m-%d}";
              tooltip-format = "{:%Y-%m-%d | %H:%M}";
            };

            pulseaudio = {
              format = "{icon}";
              format-icons = {
                default = [
                  ""
                  ""
                  ""
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

          #clock, #pulseaudio, #tray, #network, #battery, #bluetooth {
            padding-left: 10px;
            padding-right: 10px;
          }
        '';
      };
    };
  };
}
