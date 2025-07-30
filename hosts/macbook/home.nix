{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    htop
    ffmpeg
    wget
    imagemagick

    gcc
    maven
    cmake
    gnupg
    lua

    nerd-fonts.symbols-only
  ];

  dev.enable = true;

  home.stateVersion = "25.05";
}
