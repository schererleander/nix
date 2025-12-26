{
  config,
  lib,
  username,
  ...
}:

{
  options.nx.programs.gemini-cli.enable = lib.mkEnableOption "Install Gemini CLI tool";
  config = lib.mkIf config.nx.programs.gemini-cli.enable {
    home-manager.users."${username}".programs.gemini-cli = {
      enable = true;
			# Cant store credentials due config read-only
      #settings = {
      #  "ui.theme" = "Default";
      #  "general.preferredEditor" = "nvim";
      #  "general.disableAutoUpdate" = true;
      #  "privacy.usageStatisticsEnabled" = false;
      #};
    };
  };
}
