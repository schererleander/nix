{
  config,
  lib,
  username,
  ...
}:

{
  config = lib.mkIf config.nx.desktop.gnome.enable {
    home-manager.users."${username}".dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
