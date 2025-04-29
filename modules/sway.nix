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
	terminal = "${pkgs.wmenu}/bin/wmenu-run -b -N 000000";
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
