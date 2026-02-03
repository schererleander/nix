{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.mullvad-vpn;
in
{
  options.nx.mullvad-vpn.enable = mkEnableOption "Mullvad VPN";

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    environment.systemPackages = [ pkgs.mullvad-vpn ];
  };
}
