{
  config,
  lib,
  ...
}:

{
  options.nx.services.keyring.enable = lib.mkEnableOption "Enable keyring service";

  config = lib.mkIf config.nx.services.keyring.enable {
    security.pam.services.login.enableKwallet = lib.mkIf config.nx.desktop.kde.enable true;

    # default keyring to use
    services.gnome.gnome-keyring.enable = lib.mkIf (!config.nx.desktop.kde.enable) true;
  };
}
