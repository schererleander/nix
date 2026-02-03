{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.hardware.printer;
in
{
  options.nx.hardware.printer.enable = mkEnableOption "printer support";

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
