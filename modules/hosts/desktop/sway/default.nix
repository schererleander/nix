{
  config,
  username,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf mkOptionDefault types;
  cfg = config.nx.desktop.sway;
  mod = "Mod4";
in
{
  options.nx.desktop.sway = {
    enable = mkEnableOption "Enable sway";
    monitors = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          resolution = mkOption {
            type = types.str;
            description = "Monitor resolution and refresh rate";
            example = "1920x1080@240Hz";
          };
          position = mkOption {
            type = types.str;
            default = "0 0";
            description = "Monitor position";
            example = "1920 0";
          };
        };
      });
      default = { };
      description = "Monitor configuration";
    };
    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Wallpaper image path";
    };
  };

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
              xkb_layout = config.console.keyMap;
            };
          };

          output = lib.mapAttrs (name: monitor: {
            resolution = monitor.resolution;
            position = monitor.position;
          } // (if cfg.wallpaper != null then { bg = "${cfg.wallpaper} fill"; } else { })) cfg.monitors;

          gaps = {
            inner = 15;
          };

          window = {
            titlebar = false;
            border = 0;
          };

          modifier = mod;

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
              command = "${pkgs.waybar}/bin/waybar";
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

      # swaylock
      programs.swaylock = {
        enable = true;
        settings = {
          font = "monospace 12";
          color = "00000000";
          ring-color = "ffffffff";
          key-hl-color = "ff0000ff";
          bs-hl-color = "ff0000ff";
        };
      };

      # swayidle
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
          }
          {
            timeout = 600;
            command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
            resumeCommand = "${pkgs.sway}/bin/swaymsg output * dpms on";
          }
          {
            timeout = 900;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
        events = [
          {
            event = "after-resume";
            command = "${pkgs.sway}/bin/swaymsg output * dpms on";
          }
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
          }
        ];
      };
    };
  };
}
