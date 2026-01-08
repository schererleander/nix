{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.nx.productivity.anki;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.productivity.anki = {
    enable = mkOption {
      description = "Anki free and open-source flashcard program";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
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
