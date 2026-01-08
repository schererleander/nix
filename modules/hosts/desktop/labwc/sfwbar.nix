{
  config,
  username,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.desktop.sfwbar;
in
{
  options.nx.desktop.sfwbar.enable = mkEnableOption "Enable sfwbar" // {
    default = config.nx.desktop.labwc.enable;
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        sfwbar
        gtk-layer-shell
      ];

      # CONFIGURATION
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

                  # System Monitors
                  #include("${pkgs.sfwbar}/share/sfwbar/cpu.widget")
                  #include("${pkgs.sfwbar}/share/sfwbar/memory.widget")

                  # Tray
                  tray {
                    rows = 1
                  }

                  # --- MODULES ---
                  #include("${pkgs.sfwbar}/share/sfwbar/upower.widget")
                  #include("${pkgs.sfwbar}/share/sfwbar/battery-svg.widget")
                  
                  #include("${pkgs.sfwbar}/share/sfwbar/idle.widget")
                  #include("${pkgs.sfwbar}/share/sfwbar/backlight.widget")
                  include("${pkgs.sfwbar}/share/sfwbar/volume.widget")
                  #include("${pkgs.sfwbar}/share/sfwbar/network-module.widget")
                  #include("${pkgs.sfwbar}/share/sfwbar/sway-lang.widget")

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
