{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.cli.opencode;
  inherit (lib) mkOption types mkIf;
in
{

  options.nx.cli.opencode = {
    enable = mkOption {
      description = "opencode open source ai coding agent";
      type = types.bool;
      default = false;
    };
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
