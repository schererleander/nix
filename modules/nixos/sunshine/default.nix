{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.sunshine;
in
{
  options.nx.sunshine.enable = mkEnableOption "Sunshine game streaming server";

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    hardware.graphics.enable = true;
  };
}
