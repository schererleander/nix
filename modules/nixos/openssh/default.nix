{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.nx.services.openssh;
in
{
  options.nx.services.openssh = {
    enable = mkEnableOption "OpenSSH server";
    allowedUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.AllowUsers = cfg.allowedUsers;
    };
  };
}
