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

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
            user = "greeter";
          };
        };
      };
    };

  flake.modules.homeManager.sway =
    { lib, pkgs, ... }:
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
              resolution = "2160x1440@240Hz";
            };
          };

          gaps = {
            inner = 15;
          };

          window = {
            titlebar = false;
            border = 0;
          };

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
    };
}
