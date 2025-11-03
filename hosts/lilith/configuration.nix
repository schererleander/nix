{
  pkgs,
  host,
  inputs,
  username,
  ...
}:

{
  imports = [
    ../../modules
  ];

  users.users.${username}.home = "/Users/${username}";

  networking.hostName = host;

  home-manager.users.${username} = {
    imports = [
      inputs.mac-app-util.homeManagerModules.default
    ];

    home.username = username;
    home.homeDirectory = "/Users/${username}";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      htop
      ffmpeg
      wget
      imagemagick

      zathura
      zoxide
      gemini-cli

      nerd-fonts.symbols-only
    ];
    home.stateVersion = "25.05";
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
      "obsidian"
      "nextcloud"
      "mullvad-vpn"
      "bambu-studio"
      "arduino-ide"
      "iterm2"
      "docker-desktop"
      "rectangle"
      "slack"
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
      vscode.enable = true;
    };
  };

  

  system.stateVersion = 5;
}
