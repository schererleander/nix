{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.productivity.nextcloud-client;
in
{
	options.nx.productivity.nextcloud-client = {
		enable = mkOption {
			description = "Client for nextcloud";
			type = types.bool;
			default = false;
		};
	};
  config = mkIf cfg.enable {
    #home.packages = with pkgs; [ nextcloud-client ];
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
