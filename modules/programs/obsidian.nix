{
  config,
  lib,
  username,
  ...
}:

{
  options.nx.programs.obsidian.enable = lib.mkEnableOption "Obsidian note-taking application";
  config = lib.mkIf config.nx.programs.obsidian.enable {
    home-manager.users."${username}" = {
      programs.obsidian = {
        enable = true;
      };
    };
  };
}
