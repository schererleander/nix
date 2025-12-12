{
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
    ../../modules/programs
    ../../modules/system
    ../../modules/services
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    initrd = {
      luks.devices."luks-803851e9-7fa8-4367-a927-0bb76d0fe830".device =
        "/dev/disk/by-uuid/803851e9-7fa8-4367-a927-0bb76d0fe830";
    };
    consoleLogLevel = 3;
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.consoleMode = "max";
    };
    plymouth = {
      enable = true;
      theme = "lone";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "lone" ];
        })
      ];
    };
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.dconf.enable = true;

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      firefox
      blender
      godot
      imv
      mpv

      zoxide

      noto-fonts-cjk-sans
			noto-fonts-color-emoji
    ];

    programs.zsh.shellAliases = {
      open = "xdg-open";
    };
    
    home.stateVersion = "25.11";
  };

  nx = {
    desktop = {
      cinnamon.enable = true;
    };
    programs = {
      kitty.enable = true;
      git.enable = true;
      gh.enable = true;
      gpg.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      spicetify.enable = true;
      obsidian.enable = true;
      gemini-cli.enable = true;
      opencode.enable = true;
      nixcord.enable = true;
    };
    services = {
      openssh.enable = true;
      printer.enable = true;
      pipewire.enable = true;
      polkit.enable = true;
      wooting.enable = true;
      mullvad.enable = true;
      nextcloud-client.enable = true;
    };
  };

  system.stateVersion = "25.11";
}
