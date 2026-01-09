{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.hardware.audio;
in
{
  options.nx.hardware.audio.enable = mkEnableOption "PipeWire audio";

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
