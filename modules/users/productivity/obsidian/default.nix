{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.productivity.obsidian;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.productivity.obsidian = {
    enable = mkOption {
      description = "Obsidian note-taking application";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
    };
  };
}
