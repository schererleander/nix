{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.nx.desktop.cinnamon;
in
{
  options.nx.desktop.cinnamon.enable = mkEnableOption "Enable Cinnamon desktop environment";

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    services.speechd.enable = mkForce false;
    services.orca.enable = mkForce false;

    environment.systemPackages = with pkgs; [
      nemo-preview
    ];
  };
}
