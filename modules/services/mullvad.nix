{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nx.services.mullvad.enable = lib.mkEnableOption "Enable and setup mullvad";
  config = lib.mkIf config.nx.services.mullvad.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
