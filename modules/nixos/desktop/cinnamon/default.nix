{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.nx.desktop.cinnamon;
in
{
  options.nx.desktop.cinnamon.enable = mkEnableOption "Cinnamon desktop";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
    };
    services.speechd.enable = mkForce false;
    services.orca.enable = mkForce false;
    environment.systemPackages = [ pkgs.nemo-preview ];
  };
}
