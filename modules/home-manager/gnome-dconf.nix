{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.gnome-dconf.enable = lib.mkEnableOption "Enable gnome dconf settings";
  config = lib.mkIf config.gnome-dconf.enable {
    packages = with pkgs; [
      gnomeExtensions.dash-to-panel
			gnomeExtensions.user-theme
    ];
    dconf = {
      settings = {
        "/org/gnome/desktop/interface/" = {
          color-scheme = "'prefer-dark'";
        };
      };
    };
  };
}
