{
  config,
	username,
  lib,
  ...
}:

{
  options.nx.programs.kitty.enable = lib.mkEnableOption "Enable git";
  config = lib.mkIf config.nx.programs.kitty.enable {
		home-manager.users.${username} = {
			programs.kitty = {
				enable = true;
				enableGitIntegration = true;
				settings = {
					enable_audio_bell = false;
				};
			};
		};
 };
}

