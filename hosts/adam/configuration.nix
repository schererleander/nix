{
  inputs,
  system,
  host,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
		../../modules/system
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    initrd = {
      luks.devices."luks-0689cc49-e7d8-4eaa-ac8e-d4fd711217ac".device =
        "/dev/disk/by-uuid/0689cc49-e7d8-4eaa-ac8e-d4fd711217ac";
      verbose = false;
    };
    consoleLogLevel = 3;
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.consoleMode = "max";
    };
    plymouth = {
      enable = true;
    };
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      obsidian
      firefox
      imv
      mpv

      nextcloud-client

      xdg-utils
      pulsemixer
    ];
    home.stateVersion = "25.05";
  };

  nx = {
    desktop = {
      sway.enable = true;
      waybar.enable = true;
      dunst.enable = true;
    };
    programs = {
      gh.enable = true;
      gpg.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      foot.enable = true;
      spicetify.enable = true;
      zathura.enable = true;
    };
    services = {
      printer.enable = true;
      pipewire.enable = true;
      polkit.enable = true;
      mullvad.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
