{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    ../../modules
  ];

  home.username = "schererleander";
  home.homeDirectory = "/Users/schererleander";
  
  home.packages = with pkgs; [
    htop
    ffmpeg
    pfetch
    
    #dev
    gcc
    lua-language-server
    pyright
    jdk
    nodejs

    obsidian
    
  ];

  zsh.enable = true;
  tmux.enable = true;
  git.enable = true;
  neovim.enable = true;

  chromium.enable = true;
  vscode.enable = true;

  home.stateVersion = "24.11";
}
