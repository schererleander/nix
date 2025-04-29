{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.nixcord;
in {
  options.nixcord.enable = lib.mkEnableOption "Enable nixord and setup";
  config = lib.mkIf cfg.enable {
    programs.nixcord = {
      enable = true;
      config = {
        themeLinks = [
          "https://github.com/TheCommieAxolotl/BetterDiscord-Stuff/blob/main/Ultra/Ultra.theme.css"
        ];
        frameless = true;
        plugins = {
          alwaysAnimate.enable = true;
          clearURLs.enable = true;
        };
      };
    };
  };
}
