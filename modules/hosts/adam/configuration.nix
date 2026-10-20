{
  flake.modules.nixos.adam =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      home-manager.users.schererleander = {
        imports = [ inputs.self.modules.homeManager.vlc ];
      };
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

      systemd.services.NetworkManager-wait-online.enable = false;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      users.users.schererleander = {
        isNormalUser = true;
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "input"
          "fuse"
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

      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "25.11";
    };
}
