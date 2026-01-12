{ config, lib, ... }:
let
  cfg = config.nx.media.mpv;
  inherit (lib)
    mkEnableOption
    types
    optional
    mkIf
    mkOption
    ;
in
{
  options.nx.media.mpv = {
    enable = mkEnableOption "a free, open source, and cross-platform media player";
    hdrExpansion = mkEnableOption "SDR to HDR inverse tone mapping";
    targetPeak = mkOption {
      description = "Peak brightness of the display";
      type = types.int;
      default = 500; # For MO27Q28G
    };
  };
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        target-peak = cfg.targetPeak;
        target-colorspace-hint = "yes";
      };
      profiles = {
        # Dolby Vision profile
        "DOVI" = {
          profile-restore = "copy";
          profile-cond = "p[\"video-dec-params/gamma\"] == \"auto\"";
          target-trc = "pq";
          target-prim = "bt.2020";
          target-peak = cfg.targetPeak;
          tone-mapping-mode = "auto";
        };

        # SDR look while in HDR
        "SDR" = {
          profile-restore = "copy";
          target-trc = "pq";
          target-prim = "bt.2020";
          target-peak = 207;
          tone-mapping = "bt.2390";
          tone-mapping-mode = "rgb";
          inverse-tone-mapping = "yes";
        };

        # SDR to HDR inverse tone mapping
        "SDR_HDR_EFFECT" = {
          profile-restore = "copy";
          target-trc = "pq";
          target-prim = "bt.2020";
          target-peak = 406;
          tone-mapping = "spline";
          tone-mapping-mode = "rgb";
          inverse-tone-mapping = "yes";
        };
      };
      defaultProfiles = optional cfg.hdrExpansion "HDR_MODE:SDR_HDR_EFFECT";
    };
  };
}
