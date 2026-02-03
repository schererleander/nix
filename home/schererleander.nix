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
      jetbrains.idea
      anki
      obsidian
      typst
      nerd-fonts.symbols-only
    ]
    ++ optionals (!isDarwin) [
      mpv
      firefox
      arduino-ide
      nextcloud-client
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

    editors = {
      neovim.enable = true;
      zed-editor.enable = true;
    };

    programs.git.enable = true;
    cli.opencode.enable = true;

    media = {
      spicetify.enable = true;
      nixcord.enable = true;
      jellyfin-mpv-shim.enable = !isDarwin;
    };

    productivity = {
      latex.enable = true;
    };
  };
}
