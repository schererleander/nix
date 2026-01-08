{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.gnome;
in
{
  options.nx.desktop.gnome.enable = mkEnableOption "Enable GNOME desktop environment";

  config = mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
      epiphany
    ];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.pop-shell
      gnomeExtensions.blur-my-shell
      gnome-tweaks
    ];
  };
}
