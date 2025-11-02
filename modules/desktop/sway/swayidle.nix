{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  options.nx.desktop.swayidle.enable = lib.mkEnableOption "Enable swayidle configuration" // {
    default = config.nx.desktop.sway.enable;
  };
  config = lib.mkIf config.nx.desktop.swayidle.enable {
    home-manager.users."${username}" = {
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
          }
          {
            timeout = 600;
            command = "${pkgs.sway}/bin/swaymsg 'output * dpms off";
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
