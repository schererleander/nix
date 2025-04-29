{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    ../../modules/home-manager
  ];

  home.username = "leander";
  home.homeDirectory = "/home/leander";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    fzf
    imv

    #dev
    gcc

    # fomts
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

  foot.enable = true;
  neovim.enable = true;
  git.enable = true;
  zsh.enable = true;
  tmux.enable = true;

  sway.enable = true;
  waybar.enable = true;
  spicetify.enable = true;
  nixcord.enable = true;
  home.stateVersion = "24.11";
}
