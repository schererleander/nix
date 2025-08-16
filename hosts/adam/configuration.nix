{ pkgs, host, username, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./wooting.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
