{ config, lib, ... }:
let
  cfg = config.nx.media.jellyfin-mpv-shim;
  inherit (lib) mkEnableOption mkIf optionalAttrs;
in
{
  options.nx.media.jellyfin-mpv-shim = {
    enable = mkEnableOption "Jellyfin MPV Shim";
  };

  config = mkIf cfg.enable {
    systemd.user.services.jellyfin-mpv-shim.Service.Environment = [
      "ENABLE_HDR_WSI=1"
    ];

    services.jellyfin-mpv-shim = {
      enable = true;
      settings = {
        player_name = "mpv-shim";
        allow_transcode_to_h256 = true;
      };
      mpvConfig = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        target-colorspace-hint = "yes";
        target-peak = 500;
      }
      // (optionalAttrs false {
        target-trc = "pq";
        target-prim = "bt.2020";
        #target-peak = 406;
        #tone-mapping = "spline";
        #tone-mapping-mode = "rgb";
        inverse-tone-mapping = "yes";
      });
    };
  };
}
