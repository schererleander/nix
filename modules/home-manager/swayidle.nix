{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.swayidle.enable = lib.mkEnableOption "Enable swayidle configuration";
  config = lib.mkIf config.swayidle.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timout = "600";
          command = "${pkgs.sway}/bin/swaymsg output * dpms off";
        }
        {
          timout = "900";
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
			events = [
				{ event = "resume"; command = "${pkgs.sway}/bin/swaymsg output * dpms on"; }
				{ event = "before-sleep"; command = "${pkgs.hyprlock}/bin/hyprlock"; }
			];
    };
  };
}
