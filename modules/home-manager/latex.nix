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
			# See https://mynixos.com/search?q=texlivepackages.collection for more collections
			# and https://mynixos.com/search?q=texlivepackages for more individual packages.
      extraPackages = tpkgs: { inherit (tpkgs) collection-basic collection-latex collection-latexrecommended biblatex; };
    };

    home.packages = with pkgs; [
      biber
    ];

    programs.pandoc = {
      enable = true;
      defaults = {
        pdf-engine = "pdfetex";
      };
    };
  };
}
