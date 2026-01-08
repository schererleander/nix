{
  pkgs,
  host,
  username,
  ...
}:

{
  networking.hostName = host;

  nx.user.${username} = {
    stateVersion = "25.11";
    packages = with pkgs; [
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
    sessionVariables = {
      PATH = "/opt/homebrew/opt/openjdk@21/bin:$PATH";
    };

    nx = {
      terminal.defaultShell = "zsh";

      editors.neovim = {
        enable = true;
        langs = {
          python = true;
          go = true;
          java = true;
          latex = true;
        };
      };
      git.enable = true;
      cli.opencode.enable = true;
      media = {
        spicetify.enable = true;
        nixcord.enable = true;
      };
      productivity = {
        obsidian.enable = true;
        latex.enable = true;
      };
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

  nix.enable = false;

  system.stateVersion = 5;
}
