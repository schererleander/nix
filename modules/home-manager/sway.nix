{
  config,
  lib,
  pkgs,
  username,
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
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          immediate_render = true;
        };

        background = [
          {
            monitor = "";
            path = "/etc/nixos/images/pond.jpg";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "300, 30";
            outline_thickness = 0;
            dots_size = 0.25;
            dots_spacing = 0.55;
            dots_center = true;
            dots_rounding = -1;
            outer_color = "rgba(242, 243, 244, 0)";
            inner_color = "rgba(242, 243, 244, 0)";
            font_color = "rgba(242, 243, 244, 0.75)";
            fade_on_empty = false;
            placeholder_text = "";
            hide_input = false;
            check_color = "rgba(204, 136, 34, 0)";
            fail_color = "rgba(204, 34, 34, 0)";
            fail_text = "$FAIL <b>($ATTEMPTS)</b>";
            fail_transition = 300;
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1;
            invert_numlock = false;
            swap_font_color = false;
            position = "0, -468";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 20;
            position = "0, 405";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%k:%M")"'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 93;
            position = "0, 310";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "${username}";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 12;
            position = "0, -407";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "Enter Password";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 10;
            position = "0, -438";
            halign = "center";
            valign = "center";
          }
        ];

        image = [
          {
            monitor = "";
            path = "/etc/nixos/images/pf.jpg";
            border_color = "0xffdddddd";
            border_size = 0;
            size = 73;
            rounding = -1;
            rotate = 0;
            reload_time = -1;
            reload_cmd = "";
            position = "0, -353";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 60;
          command = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 90;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
