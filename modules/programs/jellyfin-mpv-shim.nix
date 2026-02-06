{
  flake.modules.homeManager.jellyfin-mpv-shim =
    {
      lib,
      ...
    }:
    let
      inherit (lib) optionalAttrs;
    in
    {
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
          UP = "add chapter 1";
          DOWN = "add chapter -1";
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
