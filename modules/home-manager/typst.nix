{
  config,
	pkgs,
  lib,
  ...
}:

{
  options.typst.enable = lib.mkEnableOption "Setup typst";
  config = lib.mkIf config.typst.enable {
    home.packages = with pkgs; [
      typst
			typst-fmt
    ];
  };
}
