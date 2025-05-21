{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../../modules
  ];

  home.username = "schererleander";
  home.homeDirectory = "/Users/schererleander";
  
  home.packages = with pkgs; [
    htop
    ffmpeg
    pfetch
    wget
    mas

    #dev
    gcc
    maven
    cmake
    lua-language-server
    pyright
    go
    nodejs
    typst
    tailwindcss

    obsidian
    iterm2
    appcleaner
    rectangle
    jetbrains.idea-community-bin

    nerd-fonts.symbols-only
    nerd-fonts.space-mono
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
  aerospace.enable = true;

  home.stateVersion = "24.11";
}
