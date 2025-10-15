{
  config,
  lib,
  pkgs,
  ...
}:

let
  mod = config.wayland.windowManager.sway.config.modifier;
in
{
  options.sway.enable = lib.mkEnableOption "Enable sway and setup";
  config = lib.mkIf config.sway.enable {
    home.packages = with pkgs; [
      wmenu
      swaybg
      sway-contrib.grimshot
      wl-clipboard
      xdg-utils
      playerctl
    ];

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      config = {
        input = {
          "*" = {
            xkb_layout = "de";
          };
        };

        output = {
          DP-1 = {
            resolution = "1920x1080@240Hz";
            bg = "/etc/nixos/images/pond.jpg fill";
          };
        };

        gaps = {
          inner = 15;
        };

        window = {
          titlebar = false;
          border = 0;
        };

        modifier = "Mod4";

        keybindings = lib.mkOptionDefault {
          "${mod}+q" = "kill";
          "${mod}+Shift+s" = "exec grimshot savecopy area";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ +5%";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ -5%";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_DEVICE@ toggle";
        };

        menu = "${pkgs.wmenu}/bin/wmenu-run -b -N 000000E6";
        terminal = "${pkgs.foot}/bin/foot";
        defaultWorkspace = "workspace number 1";

        bars = [
          {
            "command" = "${pkgs.waybar}/bin/waybar";
          }
        ];
      };
      checkConfig = false;
      wrapperFeatures.base = true;
      wrapperFeatures.gtk = true;
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SCREENSHOTS_DIR = "~/Pictures/Screenshots/";
    };
  };
}
