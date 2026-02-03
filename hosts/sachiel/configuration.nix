{
  pkgs,
  host,
  ...
}:

let
  username = "administrator";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  boot.loader.grub.configurationLimit = 2;
  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

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
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:schererleander/nix#${host}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    allowReboot = true;

    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  nx.server = {
    openssh = {
      enable = true;
      allowedUsers = [ username ];
    };
    nginx.enable = true;
    nextcloud = {
      enable = true;
      user = username;
    };
    site.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
