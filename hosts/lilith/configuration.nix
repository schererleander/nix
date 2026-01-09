{
  host,
  ...
}:

let
  username = "schererleander";
in
{
  networking.hostName = host;

  # User configuration
  users.users.${username}.home = "/Users/${username}";

  home-manager.users.${username} = {
    imports = [ ../../home/schererleander.nix ];
    home.username = username;
    home.homeDirectory = "/Users/${username}";
  };

  system.primaryUser = username;
  system.defaults = {
    dock = {
      autohide = true;
      largesize = 48;
      show-recents = false;
    };
    WindowManager.EnableStandardClickToShowDesktop = false;
    finder = {
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
      "mullvad-vpn"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  nix.enable = false;

  system.stateVersion = 5;
}
