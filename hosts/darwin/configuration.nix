{ config, pkgs, lib, ...}:

{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.schererleander.home = "/Users/schererleander";

  system.primaryUser = "schererleander";
  system.defaults = {
    dock = {
      autohide = true;
      largesize = 48;
      show-recents = false;
    };
    WindowManager.EnableStandardClickToShowDesktop = false;
    finder = {
      #ShowPathbar = true;
      #ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    controlcenter = {
      Display = false;
      FocusModes = false;
      Sound = false;
    };
    loginwindow.GuestEnabled = false;
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
      "arduino-ide"
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
