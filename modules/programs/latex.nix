{
  flake.modules.homeManager.latex =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (texliveSmall.withPackages (
          tpkgs: with tpkgs; [
            collection-basic
            collection-latex
            collection-latexrecommended
            biblatex
          ]
        ))
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
