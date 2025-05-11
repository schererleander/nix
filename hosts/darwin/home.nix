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
    mas
    
    #dev
    gcc
    maven
    cmake
    lua-language-server
    pyright
    go
    nodejs

    obsidian
    iterm2
    appcleaner
    rectangle
    jetbrains.idea-community-bin
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "SpaceMono" "IBMPlexMono" ]; })
  ];

  zsh.enable = true;
  tmux.enable = true;
  git.enable = true;
  nvf.enable = true;

  # No aarh64-darwin
  #chromium.enable = true;
  spicetify.enable = true;
  zathura.enable = true;
  vscode.enable = true;

  home.stateVersion = "24.11";
}
