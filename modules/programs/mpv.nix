{
  flake.modules.homeManager.mpv = {
    programs.mpv = {
      enable = true;
      config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        target-peak = 500;
        target-colorspace-hint = "yes";
      };
      bindings = {
        UP = "add chapter 1";
        DOWN = "add chapter -1";
      };
      profiles = {
        # Dolby Vision profile
        "DOVI" = {
          profile-restore = "copy";
          profile-cond = "p[\"video-dec-params/gamma\"] == \"auto\"";
          target-trc = "pq";
          target-prim = "bt.2020";
          target-peak = 500;
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
    };
  };
}
