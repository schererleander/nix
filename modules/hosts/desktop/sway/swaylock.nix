{
  config,
  username,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.swaylock;
in
{
  options.nx.desktop.swaylock.enable = mkEnableOption "Enable and setup swaylock" // {
    default = config.nx.desktop.sway.enable;
  };
  config = mkIf cfg.enable {
    home-manager.users."${username}" = {
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
    };
  };
}
