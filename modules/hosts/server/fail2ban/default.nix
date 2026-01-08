{
  config,
  pkgs,
  options,
  lib,
  ...
}:
let
  cfg = config.nx.server.fail2ban;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.server.fail2ban = {
    enable = mkOption {
      description = "Setup fail2ban service";
      type = types.bool;
      default = false;
    };
    bantime = mkOption {
      description = "default bantime";
      type = types.str;
      default = "1h";
    };
  };
  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime = cfg.bantime;
    };
  };
}
