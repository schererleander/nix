{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.nx.server = {
    enable = mkOption {
      description = "Set this host as server";
      type = types.bool;
      default = false;
    };
    timeZone = mkOption {
      description = "Time Zone of the server";
      type = types.str;
      default = "Europe/Berlin";
    };
  };

  imports = [
    ./openssh
    ./nginx
    ./fail2ban
    ./nextcloud
    ./site
  ];
}
