{
  config,
	username,
  lib,
  ...
}:

{
  options.nx.programs.anki.enable = lib.mkEnableOption "Enable anki";
  config = lib.mkIf config.anki.enable {
	  #Wait for stable release
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
