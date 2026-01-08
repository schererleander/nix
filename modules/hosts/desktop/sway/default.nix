{
  config,
  username,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOptionDefault;
  mod = config.home-manager.users.${username}.wayland.windowManager.sway.config.modifier;
  cfg = config.nx.desktop.sway;
in
{
  imports = [
    ./swayidle.nix
    ./swaylock.nix
  ];

  options.nx.desktop.sway.enable = mkEnableOption "Enable sway and setup";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        wmenu
        swaybg
        sway-contrib.grimshot
        wl-clipboard
        xdg-utils
      ];

      wayland.windowManager.sway = {
        enable = true;
        systemd = {
          enable = true;
          xdgAutostart = true;
        };
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

          keybindings = mkOptionDefault {
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

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
    };
  };
}
