{
  config,
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
