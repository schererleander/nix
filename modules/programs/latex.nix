{
  config,
  username,
  pkgs,
  lib,
  ...
}:

{
  options.nx.programs.latex.enable = lib.mkEnableOption "Setup latex";
  config = lib.mkIf config.nx.programs.latex.enable {
    home-manager.users.${username} = {
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
  };
}