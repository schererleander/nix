{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.spicetify;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  options.spicetify.enable = lib.mkEnableOption "Enable and configure Spicetify";
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
      colorScheme = "coral";
    };
  };
}
