{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  options.spicetify.enable = lib.mkEnableOption "Enable Spicetify integration";
  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        sonicDancing
        modernScrollbar
        nyanCatProgressBar
        declutterNowPlayingBar
      ];
      theme = spicePkgs.themes.sleek;
      colorScheme = "Coral";
    };
  };
}
