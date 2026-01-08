{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.dunst;
in
{
  options.nx.desktop.dunst.enable = mkEnableOption "Enable dunst notification";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libnotify
      ];

      services.dunst = {
        enable = true;
        settings = {
          global = {
            font = "monospace 10";
            offset = "(15, 15)";
            frame_width = 0;
          };
          urgency_low = {
            foreground = "#FFFFFF";
            background = "#000000E6";
          };

          urgency_normal = {
            foreground = "#FFFFFF";
            background = "#000000E6";
          };

          urgency_critical = {
            foreground = "#FFFFFF";
            background = "#000000E6";
          };
        };
      };
    };
  };
}
