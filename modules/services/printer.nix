{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.nx.services.printer.enable = lib.mkEnableOption "Enable printer service";
  config = lib.mkIf config.nx.services.printer.enable {
		services.printing = {
			enable = true;
			drivers = [ pkgs.brlaser ];
		};
		# printer autodiscovery
		services.avahi = {
			enable = true;
			nssmdns4 = true;
			openFirewall = true;
		};
  };
}
