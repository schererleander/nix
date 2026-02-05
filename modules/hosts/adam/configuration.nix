{
  flake.modules.nixos.adam =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ "amd_pstate=active" ];
        initrd.luks.devices."luks-803851e9-7fa8-4367-a927-0bb76d0fe830".device =
          "/dev/disk/by-uuid/803851e9-7fa8-4367-a927-0bb76d0fe830";
        loader = {
          timeout = 0;
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # Localisation
      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };

      # Disable waiting for network to be online
      systemd.services.NetworkManager-wait-online.enable = false;

      # User configuration
      users.users.schererleander = {
        isNormalUser = true;
        home = "/home/schererleander";
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "input"
        ];
      };

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "25.11";
    };
}
