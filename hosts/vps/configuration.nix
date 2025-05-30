{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vps";
  networking.domain = "";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.administrator = {
    isNormalUser = true;
    password = "admin";
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
  ];

  services.openssh = {
    enable = true;
    ports = [ 8693 ];
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."schererleander.de" = {
      root = "/var/www/site";
      sslCertificate    = "/etc/ssl/certs/schererleander.de.crt";
      sslCertificateKey = "/etc/ssl/private/schererleander.de.key";
      forceSSL = true;
    };
    virtualHosts."cloud.schererleander.de" = {
      sslCertificate    = "/etc/ssl/certs/schererleander.de.crt";
      sslCertificateKey = "/etc/ssl/private/schererleander.de.key";
      forceSSL = true;
    };
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.schererleander.de";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    config.dbtype = "mysql";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8693 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
