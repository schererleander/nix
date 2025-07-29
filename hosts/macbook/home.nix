{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "schererleander";
  home.homeDirectory = "/Users/schererleander";
  
  home.packages = with pkgs; [
    htop
    ffmpeg
    wget
    imagemagick

    gcc
    maven
    cmake
    gnupg

    neovim

    nerd-fonts.symbols-only
  ];

  zsh.enable = true;
  tmux.enable = true;
  git.enable = true;

  home.stateVersion = "25.05";
}
