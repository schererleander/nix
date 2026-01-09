{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.cli.opencode;
  inherit (lib) mkEnableOption mkIf;
in
{

  options.nx.cli.opencode = {
    enable = mkEnableOption "opencode open source ai coding agent";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        theme = "system";
        share = "disabled";
        autoupdate = false;
      };
    };
  };
}
