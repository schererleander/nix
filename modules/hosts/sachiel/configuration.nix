{
  flake.modules.nixos.sachiel =
    {
      pkgs,
      ...
    }:
    {
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
        hostName = "sachiel";
        domain = "schererleander.de";
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

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "25.05";
    };
}
