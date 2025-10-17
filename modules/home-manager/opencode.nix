{
  config,
  lib,
  ...
}:

{
  options.opencode.enable = lib.mkEnableOption "Setup opencode";
  config = lib.mkIf config.opencode.enable {
    programs.opencode = {
      enable = true;
      settings = {
        theme = "system";
				share = "disabled";
        autoUpdate = true;
      };
    };
  };
}
