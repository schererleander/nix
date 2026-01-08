{
  config,
  username,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.labwc;

  gruvbox-openbox = pkgs.stdenv.mkDerivation {
    pname = "gruvbox-openbox";
    version = "0-unstable-2024-02-14";

    src = pkgs.fetchFromGitHub {
      owner = "nathanielevan";
      repo = "gruvbox-openbox";
      rev = "master";
      hash = "sha256-61BsD/DK6OOJLKwdY03HL1pCG1DJcIE9bsFPAVFfcIY=";
    };

    installPhase = ''
      mkdir -p $out/share/themes
      cp -r gruvbox-dark $out/share/themes/
      cp -r gruvbox-material-dark $out/share/themes/
      cp -r gruvbox-material-dark-blocks $out/share/themes/
    '';
  };
in
{
  imports = [
    ./sfwbar.nix
  ];

  options.nx.desktop.labwc.enable = mkEnableOption "Enable labwc";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        labwc-tweaks
        labwc-gtktheme
        gruvbox-material-gtk-theme
        gruvbox-dark-icons-gtk
        swaybg
        wl-clipboard

        gruvbox-openbox
      ];

      services.cliphist.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = "Gruvbox-Material-Dark";
          package = pkgs.gruvbox-material-gtk-theme;
        };
        iconTheme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-dark-icons-gtk;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      services.kanshi = {
        enable = true;
        profiles = {
          home = {
            outputs = [
              {
                criteria = "DP-1";
                mode = "1920x1080@240";
                position = "1920,0";
              }
            ];
          };
        };
      };

      wayland.windowManager.labwc = {
        enable = true;
        autostart = [
          "${pkgs.sfwbar}/bin/sfwbar"
          "${pkgs.swaybg}/bin/swaybg -m fill -i /home/${username}/Developer/nix/images/pond.jpg & disown"
        ];
        environment = [
          "XKB_DEFAULT_LAYOUT=de"
          "XCURSOR_SIZE=24"
          "XDG_CURRENT_DESKTOP=wlroots"
        ];

        menu = [
        ];

        rc = {
          core = {
            decoration = "server";
            gap = 5;
            adaptiveSync = "no";
            reuseOutputMode = "yes";
          };

          theme = {
            # "gruvbox-dark", "gruvbox-material-dark", "gruvbox-material-dark-blocks"
            name = "gruvbox-material-dark-blocks";
          };

          keyboard = {
            default = true;
            keybind = [
              {
                "@key" = "W-Return";
                action = {
                  "@name" = "Execute";
                  "@command" = "kitty";
                };
              }
              {
                "@key" = "W-F4";
                action = {
                  "@name" = "None";
                };
              }
            ];
          };

          mouse = {
            default = true;
            context = {
              "@name" = "Root";
              mousebind = {
                "@button" = "Right";
                "@action" = "Press";
                action = {
                  "@name" = "ShowMenu";
                  "@menu" = "root-menu";
                };
              };
            };
          };
        };
      };
    };
  };
}
