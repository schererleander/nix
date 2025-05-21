{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../../modules
  ];

  home.username = "leander";
  home.homeDirectory = "/home/leander";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    obsidian
    jetbrains.idea-community-bin
    localsend
    typst

    #cli
    fzf
    htop
    imv
    pfetch
    ffmpeg
    mangal

    #dev
    gcc
    maven
    cmake
    lua-language-server
    pyright
    jdk
    go
    nodejs
    tailwindcss

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.symbols-only
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
  wezterm.enable = true;
  git.enable = true;
  zsh.enable = true;
  tmux.enable = true;

  sway.enable = true;
  waybar.enable = true;
  spicetify.enable = true;
  zathura.enable = true;
  firefox.enable = true;

  nvf.enable = true;
  vscode.enable = true;
  home.stateVersion = "24.11";
}
