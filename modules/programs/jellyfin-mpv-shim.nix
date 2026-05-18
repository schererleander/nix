{
  flake.modules.homeManager.jellyfin-mpv-shim =
    {
      lib,
      ...
    }:
    {
      systemd.user.services.jellyfin-mpv-shim.Service.Environment = [
        "ENABLE_HDR_WSI=1"
      ];

      # mpvConfig only supports flat key=value; write full mpv.conf to include profile sections
      xdg.configFile."jellyfin-mpv-shim/mpv.conf".text = ''
        vo=gpu-next
        gpu-api=vulkan
        hwdec=vaapi
        target-colorspace-hint=yes
        target-contrast=inf
        target-peak=500
        hdr-compute-peak=yes
        deband=yes
        video-sync=display-resample

        [sdr-to-hdr]
        profile-cond=p["video-params/gamma"] ~= nil and p["video-params/gamma"] ~= "pq" and p["video-params/gamma"] ~= "hlg"
        profile-restore=copy-equal
        inverse-tone-mapping=yes
        tone-mapping=spline
        tone-mapping-mode=rgb
        gamut-mapping-mode=clip
        target-trc=pq
        target-prim=bt.2020
      '';

      services.jellyfin-mpv-shim = {
        enable = true;
        settings = {
          player_name = "mpv-shim";
          allow_transcode_to_h265 = true;
        };
        mpvBindings = {
          UP = "add chapter 1";
          DOWN = "add chapter -1";
        };
      };
    };
}
