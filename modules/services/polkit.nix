{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.nx.services.polkit.enable = lib.mkEnableOption "Enable and setup polkit service";
  config = lib.mkIf config.nx.services.polkit.enable {
    security.polkit.enable = true;
    systemd.services.polkit-gnome-authenticator-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
