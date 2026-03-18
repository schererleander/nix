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
          havoc
        ];
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
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
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
          modifier = "Mod4";
          terminal = "${pkgs.havoc}/bin/havoc";

          input = {
            "*" = {
              xkb_layout = "de";
            };
          };

          output = {
            DP-1 = {
              resolution = "2560x1440@279.961HZ";
              render_bit_depth = "10";
              adaptive_sync = "true";
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
          };

          menu = "${pkgs.wmenu}/bin/wmenu-run -b";
          defaultWorkspace = "workspace number 1";
        };
      };

      home.sessionVariables = {
        WLR_RENDERER = "vulkan";
      };

    };
}
