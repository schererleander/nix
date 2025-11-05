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
  };

  config = lib.mkIf config.nx.desktop.gnome.enable {
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
