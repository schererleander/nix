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

  homebrew = {
    enable = true;
    brews = [
      "openjdk@21"
    ];
    casks = [
      "nextcloud"
      "bambu-studio"
      "arduino-ide"
      "anki"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.stateVersion = 5;
}
