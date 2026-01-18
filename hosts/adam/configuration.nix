{
  pkgs,
  ...
}:

let
  username = "schererleander";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

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

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.networkmanager.enable = true;

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

  programs.dconf.enable = true;

  nx = {
    plymouth.enable = true;
    desktop.kde.enable = true;
    dns.enable = true;
    hardware.bluetooth.enable = true;
  };

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
  };

  home-manager.users.${username} = {
    imports = [ ../../home/schererleander.nix ];
    home.username = username;
    home.homeDirectory = "/home/${username}";
  };

  system.stateVersion = "25.11";
}
