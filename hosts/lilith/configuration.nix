{
  pkgs,
  host,
  username,
  ...
}:

{
  imports = [
    ../../modules/programs
  ];

  users.users.${username}.home = "/Users/${username}";

  networking.hostName = host;

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/Users/${username}";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      htop
      ffmpeg
      wget

      zathura
      gemini-cli
      iterm2
      rectangle
      slack
      podman
			jetbrains.idea-community

      nerd-fonts.symbols-only
    ];
    home.stateVersion = "25.11";
    home.sessionVariables = {
      PATH = "/opt/homebrew/opt/openjdk@21/bin:$PATH";
    };
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
      "mullvad-vpn"
      "bambu-studio"
      "arduino-ide"
      "anki"
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  nx = {
    programs = {
      neovim.enable = true;
      zsh.enable = true;
      anki.enable = true;
      spicetify.enable = true;
      zed-editor.enable = true;
      obsidian.enable = true;
			opencode.enable = true;
    };
  };

  nix.enable = false;

  system.stateVersion = 5;
}
