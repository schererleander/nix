{
  flake.modules.nixos.sunshine = { config, ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        sunshine_name = config.networking.hostName;
        controller = "disabled";
        stream_audio = "disabled";
        vk_rc_mode = 0;
        encoder = "vaapi";
      };

      applications = {
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            cmd = "steam -tenfoot";
            image-path = "steam.png";
          }
        ];
      };
    };
  };
}
