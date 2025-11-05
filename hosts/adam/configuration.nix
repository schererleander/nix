{
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/system
    ../../modules/services
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
  };

  programs.dconf.enable = true;

  environment.variables.AMD_VULKAN_ICD = "RADV";

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      firefox
      imv
      mpv
      gemini-cli

      zoxide

      xdg-utils
      pulsemixer
    ];
    home.stateVersion = "25.11";
  };

  nx = {
    desktop = {
      gnome.enable = true;
    };
    programs = {
      gh.enable = true;
      gpg.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      spicetify.enable = true;
      obsidian.enable = true;
    };
    services = {
      printer.enable = true;
      pipewire.enable = true;
      polkit.enable = true;
      wooting.enable = true;
      mullvad.enable = true;
      nextcloud-client.enable = true;
    };
  };

  system.stateVersion = "25.11";
}
