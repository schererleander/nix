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
  inherit (lib) mkOption types mkIf;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  options.nx.media.spicetify = {
    enable = mkOption {
      description = "Command-line tool to customize the official Spotify client";
      type = types.bool;
      default = false;
    };
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
