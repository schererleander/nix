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
  neovim.enable = true;

  # No aarh64-darwin
  #chromium.enable = true;
  spicetify.enable = true;
  vscode.enable = true;

  home.stateVersion = "24.11";
}
