{
  config,
  lib,
  pkgs,
  ...
}:

{

  options.dev.enable = lib.mkEnableOption "Development tools";
  config = lib.mkIf config.dev.enable {
    zsh.enable = true;
    git.enable = true;
    gh.enable = true;
    neovim.enable = true;
    tmux.enable = true;
    gpg.enable = true;

    home.packages = with pkgs; [
      zoxide

      fzf
      ffmpeg
      imagemagick
      gh
      ripgrep

      gcc
      maven
      cmake
      jdk
      go
      lua
      nodejs
      tailwindcss

      nerd-fonts.symbols-only

      jetbrains.idea-community
    ];
  };
}
