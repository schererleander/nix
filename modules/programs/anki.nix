{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  options.nx.programs.anki.enable = lib.mkEnableOption "Enable anki";
  config = lib.mkIf config.nx.programs.anki.enable {
    # Marked as broken
    #home-manager.users.${username}.programs.anki = {
      #enable = true;
      #style = "native";
      #addons = with pkgs.ankiAddons; [
      #  anki-connect
      #  review-heatmap
      #];
    #};
  };
}
