{
  config,
  lib,
  username,
  ...
}:

{
  options.hyprlock.enable = lib.mkEnableOption "Hyprlock is a screen locker for Hyprland.";
  config = lib.mkIf config.hyprlock.enable {
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
  };
}
