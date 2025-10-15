{
  config,
	pkgs,
  lib,
  ...
}:

{
  options.gnome.enable = lib.mkEnableOption "Setup gnome desktop enviroment";
  config = lib.mkIf config.gnome.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;

    programs.dconf.enable = true;

    environment.defaultPackages = with pkgs; [
      wl-clipboard
    ];

  };
}
