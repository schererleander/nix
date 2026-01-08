{ config, lib, pkgs, ... }:
let
  cfg = config.nx.mullvad-vpn;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.mullvad-vpn = {
    enable = mkOption {
      description = "Privacy focues vpn";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    environment.systemPackages = [ pkgs.mullvad-vpn ];
  };
}
