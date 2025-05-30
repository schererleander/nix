{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "my-vps";
  networking.domain = "";

  users.users.administrator = {
    isNormalUser = true;
    password = "admin";
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
  };

  services.nginx = {
    enable = true;
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
