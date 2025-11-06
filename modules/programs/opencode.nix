{
  config,
  username,
  lib,
  ...
}:

{
  options.nx.programs.opencode.enable = lib.mkEnableOption "Setup opencode";
  config = lib.mkIf config.nx.programs.opencode.enable {
    home-manager.users.${username}.programs.opencode = {
      enable = true;
      settings = {
        theme = "system";
        share = "disabled";
        autoUpdate = false;
      };
    };
  };
}
