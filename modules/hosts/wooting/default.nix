{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.wooting;
in
{
  options.nx.wooting = {
    enable = mkOption {
      description = "Setup wootility, udev rules to discover keyboards";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.wooting-udev-rules ];
    environment.systemPackages = with pkgs; [
      wootility
    ];
  };
}
