{
  config,
  username,
  lib,
  ...
}:

{
  options.nx.programs.gh.enable = lib.mkEnableOption "Setup gh";
  config = lib.mkIf config.nx.programs.gh.enable {
    home-manager.users.${username} = {
      programs.gh = {
        enable = true;
      };
    };
  };
}