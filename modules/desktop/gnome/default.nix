{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./dconf.nix
  ];

  options.nx.desktop.gnome = {
    enable = lib.mkEnableOption "Enable GNOME desktop environment";
    blur = lib.mkEnableOption "Enable Blur my Shell";
  };

  config = lib.mkIf config.nx.desktop.gnome.enable {
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs.gnome; [
      epiphany # web browser
      geary # email client
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-photos
      gnome-software
      gnome-weather
      gnome-tour
      yelp
      gnome-mines
      gnome-sudoku
      gnome-chess
    ];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.pop-shell
      (lib.optional cfg.blur pkgs.gnomeExtensions.blur-my-shell)
      gnome-tweaks
    ];
  };
}
