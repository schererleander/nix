{ ... }:

{
  users.users.administrator = {
    isNormalUser = true;
    password = "admin";
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
    ports = [ 345687 ];
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  services.nginx = {
    enable = true;
    addSSL = true;
    virtualHosts = {
      root = "/var/www/site/";
      forceSSL = true;
      serverAliases = [ "www.schererleander.de" ];
      extraConfig = ''
        index index.html;
        add_header X-Frame-Options "SAMEORIGIN";
      '';
    };
  };

  services.nextcloud = {
    enable = true;
    https = true;
    hostName = "cloud.schererleander.de";
    database.createLocally = true;
    config = {
      dbtype = "mysql";
      adminuser = "admin";
      adminpassFile = "/etc/admin-pass-file";
    };

    settings = {
      maintenace_window_start = 2;
      default_phone_region = "de";
      filelocking.enabled = true;
    };

    caching = {
      redis = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
