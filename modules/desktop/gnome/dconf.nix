{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nx.desktop.gnome;

  enabledExtensions = [
    "pop-shell@system76.com"
  ] ++ (if cfg.blur then [ "blur-my-shell@aunetx" ] else [ ]);

in
{
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        enabled-extensions = enabledExtensions;
      };
    };
  };
}
