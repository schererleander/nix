{
  flake.modules.homeManager.mpv = {
    programs.mpv = {
      enable = true;

      config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        target-colorspace-hint = "auto";
        target-colorspace-hint-mode = "target";

        target-trc = "pq";
        target-prim = "bt.2020";
        target-peak = 500;
        target-contrast = "inf";
        hdr-reference-white = 203;

        tone-mapping = "auto";
        hdr-compute-peak = "auto";
        inverse-tone-mapping = "no";
      };

      bindings = {
        UP = "add chapter 1";
        DOWN = "add chapter -1";

        "CTRL+3" = "apply-profile SDR_HDR_EFFECT";
        "CTRL+SHIFT+3" = "apply-profile SDR_HDR_EFFECT restore";
      };

      profiles = {
        DOVI = {
          profile-restore = "copy";
          profile-cond = ''
            get("video-dec-params/colormatrix", "") == "dolbyvision"
          '';

          tone-mapping = "auto";
          inverse-tone-mapping = "no";
        };

        SDR_HDR_EFFECT = {
          profile-restore = "copy";

          target-peak = 500;
          hdr-reference-white = 203;
          tone-mapping = "spline";
          inverse-tone-mapping = "yes";
        };
      };
    };
  };
}
