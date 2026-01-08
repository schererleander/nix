{
  config,
  username,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.services.openssh;
in
{
  options.nx.services.openssh.enable = mkOption {
    description = "Setup openssh server";
    type = types.bool;
    default = false;
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        AllowUsers = [ username ];
      };
    };
  };
}
