{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.nx.desktop.cinnamon = {
    enable = lib.mkEnableOption "Enable Cinnamon desktop environment";
  };

  config = lib.mkIf config.nx.desktop.cinnamon.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    services.speechd.enable = lib.mkForce false;
		services.orca.enable = lib.mkForce true;

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
