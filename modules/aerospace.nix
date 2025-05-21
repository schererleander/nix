{ config, pkgs, lib, ...}:

{
  options.aerospace.enable = lib.mkEnableOption "Enalbe aerospace and setup";
  config = lib.mkIf config.aerospace.enable {
    programs.aerospace = {
      enable = true;
      userSettings = {
        gaps = {
          outer = 5;
        };
        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
        };
      };
    };
  };
}
