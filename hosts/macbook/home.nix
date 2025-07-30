{
  pkgs,
  ...
}:

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
    lua

    nerd-fonts.symbols-only
  ];

	dev.enable = true;

  home.stateVersion = "25.05";
}
