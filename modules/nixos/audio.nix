{ config, pkgs, lib, ... }:

let
  cfg = config.audio;
in {
  options.audio.enable = lib.mkEnableOption "Enable audio with pipewire";
  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
