{
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  programs.dconf.enable = true;

  nx = {
    desktop.kde.enable = true;

    user.${username} = {
      stateVersion = "25.11";
      packages = with pkgs; [
        imv
        mpv
        firefox
        zoxide
      ];
      shellAliases = {
        open = "xdg-open";
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
          nextcloud-client.enable = true;
          obsidian.enable = true;
          latex.enable = true;
          anki.enable = true;
        };
      };
    };
  };

  system.stateVersion = "25.11";
}
