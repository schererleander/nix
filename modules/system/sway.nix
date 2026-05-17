{
  flake.modules.nixos.sway =
    { pkgs, ... }:
    {
      services.gnome.gnome-keyring.enable = true;

      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          wl-clipboard
        ];
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
        config.common.default = [ "wlr" "kde" ];
      };

      environment.sessionVariables = {
        WLR_RENDERER = "vulkan";
      };
    };

  flake.modules.homeManager.sway =
    { lib, pkgs, ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://cloud.schererleander.de/s/BgqELb7xBXna4iX/download";
        sha256 = "0r9jcsn188yygnp6i8x03h75hqwd5g79f07lym165xd33xhgls5x";
      };
    in
    {
      gtk = {
        enable = true;
        theme = {
          name = "Breeze-Dark";
          package = pkgs.kdePackages.breeze-gtk;
        };
        iconTheme = {
          name = "breeze-dark";
          package = pkgs.kdePackages.breeze-icons;
        };
        cursorTheme = {
          name = "breeze_cursors";
          package = pkgs.kdePackages.breeze;
          size = 24;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      home.pointerCursor = {
        gtk.enable = true;
        name = "breeze_cursors";
        package = pkgs.kdePackages.breeze;
        size = 24;
      };

      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
          modifier = "Mod4";
          terminal = "ghostty";

          input = {
            "*" = {
              xkb_layout = "de";
            };
          };

          output = {
            DP-1 = {
              resolution = "2560x1440@279.961HZ";
              render_bit_depth = "10";
              # disabled as mo27q28g implementation sucks, a lot of brightness flicker
              #adaptive_sync = "true";
              hdr = "on";
              bg = "${wallpaper} fill";
            };
          };

          gaps = {
            inner = 15;
          };

          window = {
            titlebar = false;
            border = 0;
          };

          bars = [
            {
              statusCommand = "${pkgs.i3status}/bin/i3status";
              trayOutput = "DP-1";
            }
          ];

          keybindings = lib.mkOptionDefault {
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_DEVICE@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_DEVICE@ -5%";
            "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_DEVICE@ toggle";
            "${modifier}+Shift+s" =
              "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | tee ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${modifier}+v" =
              "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wmenu}/bin/wmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          };

          startup = [
            { command = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"; }
            { command = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"; }
          ];

          menu = "${pkgs.wmenu}/bin/wmenu-run -b";
          defaultWorkspace = "workspace number 1";
        };
      };

      home.sessionVariables = {
        WLR_RENDERER = "vulkan";
      };

    };
}
