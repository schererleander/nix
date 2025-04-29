{ config, pkgs, ...}:

{

  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./wooting.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Time
  time.timeZone = "Europe/Berlin";

  # Keymap
  console.keyMap = "de";

  # User
  users.users.leander = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  services = {
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  # Security
  security.polkit.enable = true;

  # home manager crash when disabled
  programs.dconf.enable = true;

  audio.enable = true;
  wooting.enable = true;

  programs.zsh.enable = true;
  users.users.leander.shell = pkgs.zsh;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
