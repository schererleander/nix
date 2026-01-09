{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.nx.server.fail2ban;
in
{
  options.nx.server.fail2ban = {
    enable = mkEnableOption "fail2ban service";
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
