{
  config,
  username,
  lib,
  ...
}:
{
  options.nx.services.openssh.enable = lib.mkEnableOption "Enable openssh service";
  config = lib.mkIf config.nx.services.openssh.enable {
		services.openssh = {
			enable = true;
			settings = {
				AllowUsers = [ username ];
			};
		};
  };
}
