{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        sunshine_name = "Adam-Sunshine";
        # Force hardware encoding for AMD
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
