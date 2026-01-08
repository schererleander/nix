{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nx.productivity.typst;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.productivity.typst = {
    enable = mkOption {
      description = "Typst markup-based typesetting system";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      typst
      typst-fmt
    ];
  };
}
