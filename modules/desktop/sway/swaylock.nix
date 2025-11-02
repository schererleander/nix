{
  config,
  username,
  lib,
  ...
}:

{
  options.nx.desktop.swaylock.enable = lib.mkEnableOption "Enable and setup swaylock" // {
    default = config.nx.desktop.sway.enable;
  };
  config = lib.mkIf config.nx.desktop.swaylock.enable {
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
