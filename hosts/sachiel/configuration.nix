{
  pkgs,
  host,
  lib,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  boot.loader.grub.configurationLimit = 2;
  zramSwap.enable = true;

  networking = {
    hostName = host;
    domain = "schererleander.de";
  };

  users.users.root.hashedPassword = "!";
  users.mutableUsers = false;
  users.users.${username} = {
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
    lynis
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:schererleander/nix#${host}";
    allowReboot = true;

    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  services.fail2ban = {
    enable = true;
    bantime = "1h";
    jails = {
      sshd = {
        enabled = true;
        settings = {
          port = 8693;
          backend = "systemd";
          maxretry = 4;
          findtime = "10m";
          bantime = "1h";
        };
      };
      nextcloud = {
        enabled = true;
        settings = {
          # START modification to work with syslog instead of logile
          backend = "systemd";
          journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";
          # END modification to work with syslog instead of logile
          port = 443;
          protocol = "tcp";
          filter = "nextcloud";
          maxretry = 3;
          bantime = 86400;
          findtime = 43200;
        };
      };
    };
  };

  environment.etc = {
    # Adapted failregex for syslogs
    "fail2ban/filter.d/nextcloud.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        _groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
        failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
        datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
      ''
    );
  };

  services.openssh = {
    enable = true;
    ports = [ 8693 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ username ];
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

    virtualHosts."cloud.schererleander.de" = {
      forceSSL = true;
      sslCertificate = "/etc/ssl/schererleander.de/fullchain.pem";
      sslCertificateKey = "/etc/ssl/schererleander.de/privkey.key";
    };
  };

  services.site = {
    enable = true;
    domain = "schererleander.de";
    sslCertificate = "/etc/ssl/schererleander.de/fullchain.pem";
    sslCertificateKey = "/etc/ssl/schererleander.de/privkey.key";
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
      trusted_domains = [ "cloud.schererleander.de" ];
      logtimezone = "Europe/Berlin";
    };
  };

  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [ "-a exit,always -F arch=b64 -S execve" ];
  };

  networking.firewall = {
    allowPing = false;
    allowedTCPPorts = [
      80
      443
      8693
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
