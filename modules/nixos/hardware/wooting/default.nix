{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.hardware.wooting;
in
{
  options.nx.hardware.wooting.enable = mkEnableOption "Wooting keyboard support";

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.wooting-udev-rules ];
    environment.systemPackages = [ pkgs.wootility ];
  };
}
