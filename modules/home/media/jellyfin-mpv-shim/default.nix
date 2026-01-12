{ config, lib, ... }:
let
  cfg = config.nx.media.jellyfin-mpv-shim;
  # Reference your custom mpv options
  mpvOpt = config.nx.media.mpv;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    optionalAttrs
    ;
in
{
  options.nx.media.jellyfin-mpv-shim = {
    enable = mkEnableOption "Jellyfin MPV Shim";
    name = mkOption {
      description = "Name of player";
      type = types.str;
      default = "mpv-shim";
    };
    hdrExpansion = mkOption {
      type = types.bool;
      default = mpvOpt.hdrExpansion;
    };
    targetPeak = mkOption {
      type = types.int;
      default = mpvOpt.targetPeak;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.jellyfin-mpv-shim.Service.Environment = [
      "ENABLE_HDR_WSI=1"
    ];

    services.jellyfin-mpv-shim = {
      enable = true;
      settings = {
        player_name = cfg.name;
        allow_transcode_to_h256 = true;
      };
      mpvConfig = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        target-colorspace-hint = "yes";
        target-peak = cfg.targetPeak;
      }
      // (optionalAttrs cfg.hdrExpansion {
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
