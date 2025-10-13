{
  config,
	pkgs,
  lib,
  ...
}:

{
  options.anki.enable = lib.mkEnableOption "Enable anki";
  config = lib.mkIf config.anki.enable {
    programs.anki = {
      enable = true;
			addons = [
				pkgs.ankiAddons.review-heatmap
				pkgs.ankiAddons.recolor
			];
    };
  };
}

