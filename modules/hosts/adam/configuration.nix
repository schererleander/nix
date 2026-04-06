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
        kernelModules = [ "amdgpu" ];
        initrd.luks.devices."luks-803851e9-7fa8-4367-a927-0bb76d0fe830".device =
          "/dev/disk/by-uuid/803851e9-7fa8-4367-a927-0bb76d0fe830";
        loader = {
          timeout = 0;
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # Disable waiting for network to be online
      systemd.services.NetworkManager-wait-online.enable = false;

      # Graphics configuration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # User configuration
      users.users.schererleander = {
        isNormalUser = true;
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "input"
        ];
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      hardware.enableRedistributableFirmware = true;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "25.11";
    };
}
