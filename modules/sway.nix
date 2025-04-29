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
        keybindings = let
          mod = "Mod4";
        in
          lib.mkOptionDefault {
            "${mod}+Return" = "exec ${pkgs.foot}/bin/foot";
            "${mod}+q" = "kill";
            "${mod}+d" = "exec exec ${pkgs.wmenu}/bin/wmenu-run -b -N 000000";
            "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
            "${mod}+Tab" = "workspace back_and_forth";
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";

            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";
            "${mod}+f" = "fullscreen";
            "${mod}+Shift+space" = "floating toggle";

            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioPrev" = "exec playerctl previous";
            "XF86AudioNext" = "exec playerctl next";

            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ +5%";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_DEVICE@ -5%";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_DEVICE@ toggle";
          };
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
