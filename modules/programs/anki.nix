{
  flake.modules.homeManager.anki =
    { ... }:
    {
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
