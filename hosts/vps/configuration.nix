{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vps";
  networking.domain = "schererleander.de";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.root.hashedPassword = "!";
  users.mutableUsers = false;
  users.users.administrator = {
    isNormalUser = true;
    hashedPassword = "$6$KBblJguEyfEmuWnU$Xf0QqPVacA2qvnzZRpnSE2cmh0kNnMgtVhCrMEDI76buNzuzkuDY6EnO7jPjQlEnoczx6ZPAl2pK.SxezbVa..";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvlkqlvY4+0o7UIGnFnnRw0HeBq5v7wYJ3kY3teXxxl vps"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINL+r0l2i07pl9V9iiGqw5e2f/QAcrMhuraA25HavdNT github-deploy"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    gnutar
    gzip
    zoxide
    neovim
    htop
  ];
  
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;

    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 8693 ];
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "leander@schererleander.de";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    appendHttpConfig = ''
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      #add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self';" always;
      add_header 'Referrer-Policy' 'same-origin';
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
    '';

    virtualHosts."schererleander.de" = {
      root = "/var/www/site";
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
      };
    };
    virtualHosts."cloud.schererleander.de" = {
      sslCertificate    = "/etc/ssl/certs/schererleander.fullchain.pem";
      sslCertificateKey = "/etc/ssl/private/schererleander.key";
      forceSSL = true;
      enableACME = true;
    };
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.schererleander.de";
    https = true;
    database.createLocally = true;
    maxUploadSize = "16G";
    config = {
      dbtype = "mysql";
      adminuser = "schererleander";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    settings = {
      maintenance_window_start = 2; # 02:00
      default_phone_region = "de";
      overwriteProtocol = "https";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8693 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
