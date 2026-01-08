{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.kde;
in
{

  options.nx.desktop.kde.enable = mkEnableOption "Enable kde";
  config = mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    security.pam.services.sddm.enableKwallet = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
    ];
  };
}
