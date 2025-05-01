{ config, lib, pkgs, ... }:

let
  cfg = config.sway;
in {
  options.sway.enable = lib.mkEnableOption "Enable sway and setup";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wmenu
      swaybg
      wl-clipboard
      playerctl
    ];

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        input = {
          "*" = {
            xkb_layout = "de";
          };
        };
        output = {
          DP-1 = {
            resolution = "1920x1080@240Hz";
            bg = "/etc/nixos/jaison-lin-2WHTac8jVA8-unsplash.jpg fill";
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
	  "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ +5%";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ -5%";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_DEVICE@ toggle";
	};
	menu = "${pkgs.wmenu}/bin/wmenu-run -b -N 000000";
	terminal = "${pkgs.foot}/bin/foot";
        defaultWorkspace = "workspace number 1";
        bars = [{
          "command" = "${pkgs.waybar}/bin/waybar";
        }];
      };
      checkConfig = false;
      wrapperFeatures.base = true;
      wrapperFeatures.gtk = true;
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "wayland";
    };
  };
}
