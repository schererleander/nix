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
  options.nx.desktop.cinnamon = {
    enable = mkEnableOption "Enable Cinnamon desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    services.speechd.enable = mkForce false;
    services.orca.enable = mkForce true;

    environment.systemPackages = with pkgs; [
      nemo-preview
    ];

    environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";

    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    console.keyMap = "de";
  };
}
