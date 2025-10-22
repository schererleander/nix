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
      extraPackages = tpkgs: { inherit (tpkgs) collection-basic biblatex; };
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
