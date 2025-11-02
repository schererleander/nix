{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    obsidian
    firefox
    imv
    mpv

    nextcloud-client

    xdg-utils
    pulsemixer

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  programs.zsh.shellAliases = {
    open = "xdg-open";
  };

  dev.enable = true;

  sway.enable = true;
  foot.enable = true;
  waybar.enable = true;
  dunst.enable = true;

  spicetify.enable = true;
  zathura.enable = true;
  nixcord.enable = true;

  home.stateVersion = "25.05";
}
