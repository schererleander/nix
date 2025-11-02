{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.gnome-dconf.enable = lib.mkEnableOption "Enable gnome dconf settings";
  config = lib.mkIf config.gnome-dconf.enable {
    home.packages = with pkgs; [
    ];
    dconf = {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
          ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
  };
}
