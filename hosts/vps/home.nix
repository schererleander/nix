{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../../modules
  ];

  home.username = "administrator";
  home.homeDirectory = "/home/administrator";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
  ];

  nvf.enable = true;
  git.enable = true;
  zsh.enable = true;

  home.stateVersion = "24.11";
}
