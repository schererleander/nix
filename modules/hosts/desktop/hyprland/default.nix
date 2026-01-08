{
  config,
  username,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf types optionals;
  cfg = config.nx.desktop.hyprland;
in
{
  options.nx.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland";
    monitors = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Monitor configuration strings for Hyprland";
      example = [ "DP-1,highrr,0x0,auto" ];
    };
    lockscreen = {
      background = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Background image for hyprlock";
      };
      profileImage = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Profile image for hyprlock";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        hyprshot
        hyprpicker
      ];

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            immediate_render = true;
          };

          background = [
            ({
              monitor = "";
              color = "rgba(0, 0, 0, 1.0)";
            } // (if cfg.lockscreen.background != null then { path = "${cfg.lockscreen.background}"; } else { }))
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
          ] ++ optionals (cfg.lockscreen.profileImage != null) [
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

          image = optionals (cfg.lockscreen.profileImage != null) [
            {
              monitor = "";
              path = "${cfg.lockscreen.profileImage}";
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

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          monitor = if cfg.monitors != [ ] then cfg.monitors else [ ",preferred,auto,auto" ];

          "$background" = "rgba(000000FF)";
          "$accent" = "rgba(FFFFFFFF)";

          env = [
            "XCURSOR_SIZE,24"
          ];

          input = {
            kb_layout = config.console.keyMap;
            follow_mouse = 1;
            touchpad = {
              natural_scroll = true;
            };
          };

          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            "col.active_border" = "$accent";
            "col.inactive_border" = "$background";
            layout = "dwindle";
          };

          decoration = {
            rounding = 5;
            active_opacity = 0.8;
            inactive_opacity = 0.7;

            blur = {
              enabled = true;
              size = 4;
              passes = 4;
              ignore_opacity = true;
              contrast = 1.1;
              brightness = 1.0;
            };
          };

          animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          misc = {
            disable_hyprland_logo = true;
            vrr = 1;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          xwayland = {
            force_zero_scaling = true;
          };

          "$mod" = "SUPER";

          bind = [
            "$mod, l, exec, hyprlock"
            "$mod, s, exec, hyprshot --mode region"
            "$mod, r, exec, wofi --show run"
            "$mod, d, exec, wofi --show drun"
            "$mod, c, exec, hyprpicker -r -a"
            "$mod, return, exec, kitty"
            "$mod, q, killactive,"
            "$mod, m, exit,"
            "$mod, f, fullscreen"
            "$mod, v, togglefloating,"
            "$mod, P, pseudo,"

            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86Audiostop, exec, playerctl stop"

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"

            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"

            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        };
      };
    };
  };
}
