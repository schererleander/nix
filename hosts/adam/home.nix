{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

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
  hyprlock.enable = true;

  spicetify.enable = true;
  zathura.enable = true;
  nixcord.enable = true;

  home.stateVersion = "25.05";
}
