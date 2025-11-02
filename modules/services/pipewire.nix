{
  config,
  lib,
  ...
}:

{
  options.nx.services.pipewire.enable = lib.mkEnableOption "Enable pipewire for audio";
  config = lib.mkIf config.nx.services.pipewire.enable {
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
