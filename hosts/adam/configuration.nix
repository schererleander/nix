{
  pkgs,
  username,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.extraSpecialArgs = { inherit inputs; };

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

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    imports = [
      ../../modules/users
      inputs.nixcord.homeModules.nixcord
      inputs.spicetify-nix.homeManagerModules.spicetify
    ];

    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      imv
      mpv
      firefox

      zoxide
    ];

    programs.zsh.shellAliases = {
      open = "xdg-open";
    };

    nx = {
      #browsers.firefox.enable = true;
      editors = {
        neovim = {
          enable = true;
          langs = {
            python = true;
            go = true;
            java = true;
            latex = true;
          };
        };
      };
      git.enable = true;
      cli = {
        opencode.enable = true;
      };
      media = {
        spicetify.enable = true;
        nixcord.enable = true;
      };
      productivity = {
        obsidian.enable = true;
        latex.enable = true;
      };
    };

    home.stateVersion = "25.11";
  };

  nx = {
    desktop = {
      kde.enable = true;
    };
  };

  system.stateVersion = "25.11";
}
