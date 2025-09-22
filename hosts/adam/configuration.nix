{
  pkgs,
  host,
  username,
  ...
}:

{

  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./wooting.nix
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

  # Network
  networking = {
    hostName = host;
    networkmanager.enable = true;
  };

  # Improve startup time
  systemd.services.NetworkManager-wait-online.enable = false;

  # Time
  time.timeZone = "Europe/Berlin";

  # Keymap
  console.keyMap = "de";

  # User
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  services = {
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.polkit.enable = true;

  programs.dconf.enable = true;

  # Mullvad vpn
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
