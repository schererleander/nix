{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  cfg = config.nx.media.spicetify;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.nx.media.spicetify = {
    enable = mkEnableOption "Command-line tool to customize the official Spotify client";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    programs.spicetify = {
      enable = true;
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        sonicDancing
        modernScrollbar
        nyanCatProgressBar
        declutterNowPlayingBar
      ];

      enabledExtensions = with spicePkgs.extensions; [
        keyboardShortcut
      ];

      theme = spicePkgs.themes.sleek;
      colorScheme = "Coral";
    };
  };
}
