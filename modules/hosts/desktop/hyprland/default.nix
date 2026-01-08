{
  config,
  username,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.hyprland;
in
{
  imports = [
    ./hyprlock.nix
  ];

  options.nx.desktop.hyprland.enable = mkEnableOption "Enable hyprland and setup";
  config = mkIf cfg.enable {
    nx.desktop.hyprlock.enable = true;
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        hyprshot
        hyprpicker
      ];
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          monitor = [
            "DP-1,highrr,0x0,auto"
          ];

          "$background" = "rgba(000000FF)";
          "$accent" = "rgba(FFFFFFFF)";

          exec-once = [
          ];

          env = [
            "XCURSOR_SIZE,24"
          ];

          input = {
            kb_layout = "de";
            follow_mouse = 1;
            touchpad = {
              natural_scroll = "yes";
            };
          };

          "device:logitech-g-pro--1" = {
            sensitivity = -0.5;
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

            drop_shadow = false;
            shadow_range = 30;
            shadow_render_power = 4;
            "col.shadow" = "$background";
          };

          animations = {
            enabled = "yes";
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
            pseudotile = "yes";
            preserve_split = "yes";
          };

          master = {
            new_is_master = true;
          };

          xwayland = {
            force_zero_scaling = true;
          };

          windowrulev2 = [
            "noborder,class:(steam)"
          ];

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
