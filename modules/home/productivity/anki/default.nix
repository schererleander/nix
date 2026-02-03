{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.productivity.anki;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.nx.productivity.anki = {
    enable = mkEnableOption "Anki free and open-source flashcard program";
  };
  config = mkIf cfg.enable {
    programs.anki = {
      enable = true;
      #style = "native";
      #addons = with pkgs.ankiAddons; [
      #  anki-connect
      #  review-heatmap
      #];
    };
  };
}
