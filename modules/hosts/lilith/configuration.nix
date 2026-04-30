{
  flake.modules.darwin.lilith =
    {
      ...
    }:

    let
      username = "schererleander";
    in
    {
      networking.hostName = "lilith";

      # User configuration
      users.users.${username}.home = "/Users/${username}";

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
          "anki"
          "mullvad-vpn"
          "nextcloud"
          "iterm2"
          "rectangle"
          "tailscale-app"
        ];
        greedyCasks = true;
        masApps = {
          "AdGuard Mini" = 1440147259;
          "Goodnotes: KI-Notizen, PDF" = 1444383602;
          "WhatsApp Messenger" = 310633997;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      nix = {
        enable = false;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      nixpkgs.config.allowUnfree = true;
      system.stateVersion = 6;
    };
}
