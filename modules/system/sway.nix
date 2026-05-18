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

      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
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

          bars = [ ];

          keybindings = lib.mkOptionDefault {
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_DEVICE@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_DEVICE@ -5%";
            "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_DEVICE@ toggle";
            "${modifier}+Shift+s" =
              "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.ffmpeg}/bin/ffmpeg -i - -vf \"zscale=primariesin=bt2020:transferin=smpte2084:primaries=bt709:transfer=bt709\" -f image2pipe -c:v png - | tee ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${modifier}+v" =
              "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wmenu}/bin/wmenu -nb #000000 -nf #ffffff -sb #285577 -sf #ffffff | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
            "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
          };

          startup = [
            { command = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"; }
            { command = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"; }
            {
              command = "${pkgs.swayidle}/bin/swayidle -w"
                + " timeout 600 'swaymsg \"output * dpms off\"'"
                + " resume 'swaymsg \"output * dpms on\"'"
                + " timeout 1800 '${pkgs.swaylock}/bin/swaylock -f -c 000000'"
                + " before-sleep '${pkgs.swaylock}/bin/swaylock -f -c 000000'";
            }
          ];

          menu = "${pkgs.wmenu}/bin/wmenu-run -b -nb #000000 -nf #ffffff -sb #285577 -sf #ffffff";
          defaultWorkspace = "workspace number 1";
        };
      };

      services.mako = {
        enable = true;
        settings = {
          background-color = "#000000FF";
          text-color = "#FFFFFFFF";
          border-color = "#285577FF";
          border-size = 2;
          border-radius = 0;
          margin = "15";
          default-timeout = 5000;
        };
      };

    };
}
