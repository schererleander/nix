{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.services.audio;
in
{
  options.nx.services.audio = {
    enable = mkOption {
      description = "enable sound";
      type = types.bool;
      default = false;
    };
  };
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
