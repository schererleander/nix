{
  config,
  lib,
  pkgs,
  ...
}:

{

  options.nx.desktop.kde.enable = lib.mkEnableOption "Enable kde";
  config = lib.mkIf config.nx.desktop.kde.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
			kate
    ];
  };
}
