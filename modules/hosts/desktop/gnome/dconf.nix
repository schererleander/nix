{
  config,
  lib,
  username,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.nx.desktop.gnome;
in
{
  config = mkIf cfg.enable {
    home-manager.users."${username}".dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
