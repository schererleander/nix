{
  config,
  username,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf types optional;
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
  options.nx.desktop.labwc = {
    enable = mkEnableOption "Enable labwc";
    monitors = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          mode = mkOption {
            type = types.str;
            description = "Monitor resolution and refresh rate";
            example = "1920x1080@240";
          };
          position = mkOption {
            type = types.str;
            default = "0,0";
            description = "Monitor position";
            example = "1920,0";
          };
        };
      });
      default = { };
      description = "Monitor configuration for kanshi";
    };
    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Wallpaper image path";
    };
    theme = {
      gtk = mkOption {
        type = types.str;
        default = "Gruvbox-Material-Dark";
        description = "GTK theme name";
      };
      icons = mkOption {
        type = types.str;
        default = "Gruvbox-Dark";
        description = "Icon theme name";
      };
      cursor = mkOption {
        type = types.str;
        default = "Adwaita";
        description = "Cursor theme name";
      };
      openbox = mkOption {
        type = types.str;
        default = "gruvbox-material-dark-blocks";
        description = "Openbox/LabWC theme name";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        labwc-tweaks
        labwc-gtktheme
        gruvbox-material-gtk-theme
        gruvbox-dark-icons-gtk
        wl-clipboard
        sfwbar
        gtk-layer-shell
      ] ++ optional (cfg.wallpaper != null) swaybg
        ++ [ gruvbox-openbox ];

      services.cliphist.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = cfg.theme.gtk;
          package = pkgs.gruvbox-material-gtk-theme;
        };
        iconTheme = {
          name = cfg.theme.icons;
          package = pkgs.gruvbox-dark-icons-gtk;
        };
        cursorTheme = {
          name = cfg.theme.cursor;
          package = pkgs.adwaita-icon-theme;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      services.kanshi = mkIf (cfg.monitors != { }) {
        enable = true;
        profiles = {
          default = {
            outputs = lib.mapAttrsToList (name: monitor: {
              criteria = name;
              mode = monitor.mode;
              position = monitor.position;
            }) cfg.monitors;
          };
        };
      };

      wayland.windowManager.labwc = {
        enable = true;
        autostart = [
          "${pkgs.sfwbar}/bin/sfwbar"
        ] ++ optional (cfg.wallpaper != null) "${pkgs.swaybg}/bin/swaybg -m fill -i ${cfg.wallpaper} & disown";
        environment = [
          "XKB_DEFAULT_LAYOUT=${config.console.keyMap}"
          "XCURSOR_SIZE=24"
          "XDG_CURRENT_DESKTOP=wlroots"
        ];

        rc = {
          core = {
            decoration = "server";
            gap = 5;
          };

          theme = {
            name = cfg.theme.openbox;
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

      # sfwbar configuration
      xdg.configFile."sfwbar/sfwbar.config".text = ''
        # Term setup
        Set Term = "foot"
        Set ThicknessHint = "20px"

        # Actions
        TriggerAction "SIGRTMIN+1", SwitcherEvent "forward"
        TriggerAction "SIGRTMIN+2", SwitcherEvent "back"

        # Initialization
        Function("SfwbarInit") {
          SetLayer "top"
          SetMirror "*"
          SetExclusiveZone "auto"
        }

        # Placer (Window positioning)
        placer {
          xorigin = 5
          yorigin = 5
          xstep = 5
          ystep = 5
          children = true
        }

        # Task Switcher
        switcher {
          interval = 700
          icons = true
          labels = false
          cols = 5
        }

        # Load Standard Library Winops
        include("${pkgs.sfwbar}/share/sfwbar/winops.widget")

        # Main Layout
        layout {
          
          # Start Menu
          include("${pkgs.sfwbar}/share/sfwbar/startmenu.widget")
          
          # Show Desktop
          include("${pkgs.sfwbar}/share/sfwbar/showdesktop.widget")

          # Taskbar
          taskbar {
            rows = 1
            icons = true
            labels = false
            sort = false
            action[3] = Menu "winops"
            action[Drag] = Focus
          }

          # Spacer 
          label {
            value = ""
            style = "spacer"
          }

          # Pager
          pager {
            rows = 1
            pins = "1","2","3","4"
            preview = true
            action[Drag] = WorkspaceActivate
          }

          # Tray
          tray {
            rows = 1
          }

          # Modules
          include("${pkgs.sfwbar}/share/sfwbar/volume.widget")

          # Clock
          grid {
            style = "clock_grid"
            label {
              value = Time("%H:%M")
              tooltip = Time("%H:%M\n%x")
            }
          }
        }

        #CSS
        #spacer {
          -GtkWidget-hexpand: true;
        }

        button#taskbar_item {
          padding: 5px;
          border-radius: 0px;
          border-width: 0px;
          -GtkWidget-hexpand: false;
        }

        button#taskbar_item:hover {
          background-color: rgba(255, 255, 255, 0.1);
        }
      '';
    };
  };
}
