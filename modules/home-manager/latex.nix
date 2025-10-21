{
  config,
	pkgs,
  lib,
  ...
}:

{
  options.latex.enable = lib.mkEnableOption "Setup latex";
  config = lib.mkIf config.latex.enable {
    programs.texlive = {
      enable = true;
      extraPackages =	tpkgs: with tpkgs; [
				amsmath
				amsfonts
				amsthm
				geometry
				graphicx
				xcolor
				hyperref
				biblatex
				fontspec
				microtype
				tikz
				pgfplots
			];
    };

		home.packages = with pkgs; [
			biber
		];

		programs.pandoc = {
			enable = true;
			defaults = {
				pdf-engine = "xelatex";
			};
		};
  };
}
