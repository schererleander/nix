{ config, lib, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  options.spicetify.enable = lib.mkEnableOption "Enable Spicetify integration";
  config = lib.mkIf config.spicetify.enable {
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