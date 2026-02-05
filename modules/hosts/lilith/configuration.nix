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
          "mullvad-vpn"
          "nextcloud"
          "iterm2"
          "rectangle"
          "tailscale-app"
        ];
        masApps = {
          #"AdGuard Mini" = 1440147259;
          #"WebSSH - Sysadmin Toolbox" = 497714887;
          #"Windows App" = 1295203466;
          #"Goodnotes: KI-Notizen, PDF" = 1444383602;
          #"WhatsApp Messenger" = 310633997;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      nix = {
        enable = true;
        settings.experimental-features = [ "nix-command" "flakes" ];
      };

      nixpkgs.config.allowUnfree = true;
      system.stateVersion = 6;
    };
}
