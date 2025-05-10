{ config, lib, pkgs, ... }:

let
  cfg = config.nextcloud;
in {
  options.nextcloud.enable = lib.mkEnableOption "Enable nextcloud and setup";
  config = lib.mkIf cfg.enable {
    home.file.".netrc".text = ''default
      login exmaple
      password test123
    '';

    home.packages = pkgs.nextcloud-client;

    systemd.user = {
      services.nextcloud-autosync = {
        Unit = {
          Description = "Auto sync Nextcloud";
          After = "network-online.target";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n https://cloud.schererleander.de";
          TimeoutStopSec = "180";
          KillMode = "process";
          KillSignal = "SIGINT";
        };
        Install.WantedBy = ["multi-user.target"];
      };
      timers.nextcloud-autosync = {
        Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
        Timer.OnBootSec = "5min";
        Timer.OnUnitActiveSec = "60min";
        Install.WantedBy = ["multi-user.target" "timers.target"];
      };
      startServices = true;
    };
  };
}