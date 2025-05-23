{ config, pkgs, lib, ...}:

{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.schererleander = {
    home = "/Users/schererleander";
    shell = pkgs.zsh;
  };
  
  system.primaryUser = "schererleander";
  system.defaults = {
    dock.autohide = true;
  };

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    taps = [
      "vladdoster/formulae"
    ];
    brews = [
      "openjdk@17"
      "openjdk@21"
    ];
    casks = [
      "nextcloud"
      "bambu-studio"
      "vlc"
      "vladdoster/formulae/vimari"
    ];
    masApps = {
      "Goodnotes 6" = 1444383602;
      "WhatsApp Messenger " = 310633997;
      "Adguard for Safari" = 1440147259;
      "WireGuard" = 1451685025;
      "Infuse" = 1136220934;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.stateVersion = 5;
}
