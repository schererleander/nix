{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "leander";
  home.homeDirectory = "/home/leander";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    obsidian
		firefox
    imv
		mpv

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

	dev.enable = true;

  sway.enable = true;
  waybar.enable = true;
  foot.enable = true;
	spicetify.enable = true;
  zathura.enable = true;
	nixcord.enable = true;

  home.stateVersion = "25.05";
}
