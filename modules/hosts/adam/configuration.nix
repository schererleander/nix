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
        loader = {
          timeout = 0;
          systemd-boot.enable = pkgs.lib.mkForce false;
          efi.canTouchEfiVariables = true;
        };
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
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

      environment.systemPackages = [
        pkgs.sbctl
      ];

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
