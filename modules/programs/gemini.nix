{ config, lib, pkgs, ... }:

{
	options.programs.gemini-cli.enable = lib.mkEnableOption "Install Gemini CLI tool";
	config = lib.mkIf config.programs.gemini-cli.enable {
		programs.gemini-cli = {
			enable = true;
			settings = {
				"ui.theme" = "Default";
				"general.preferredEditor" = "nvim";
				"general.disableAutoUpdate" = true;
				"privacy.usageStatisticsEnabled" = false;
			};
		};
	};
}
