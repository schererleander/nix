{
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) optionals optionalAttrs;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.stateVersion = "25.11";

  home.packages =
    with pkgs;
    [
      htop
      ffmpeg
      wget
      zoxide
      zathura
      jetbrains.idea-community
      anki
      obsidian
      typst
      nerd-fonts.symbols-only
      nextcloud-client
    ]
    ++ optionals isDarwin [
      iterm2
      rectangle
      bambu-studio
      arduino-ide
    ]
    ++ optionals (!isDarwin) [
      mpv
      firefox
      arduino-ide
    ];

  home.sessionVariables = optionalAttrs isDarwin {
    PATH = "/opt/homebrew/opt/openjdk@21/bin:$PATH";
  };

  home.shellAliases = optionalAttrs (!isDarwin) {
    open = "xdg-open";
  };

  programs.home-manager.enable = true;

  nx = {
    shells.zsh.enable = true;

    editors.neovim = {
      enable = true;
      langs = {
        python = true;
        go = true;
        latex = true;
        nix = true;
        lua = true;
        typst = true;
      };
    };

    programs.git.enable = true;
    cli.opencode.enable = true;

    media = {
      spicetify.enable = true;
      nixcord.enable = true;
    };

    productivity = {
      latex.enable = true;
    };
  };
}
