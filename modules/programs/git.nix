{
  config,
  username,
  lib,
  ...
}:

{
  options.nx.programs.git.enable = lib.mkEnableOption "Enable git" // {
    default = true;
  };
  config = lib.mkIf config.nx.programs.git.enable {
    home-manager.users.${username} = {
      programs.git = {
        enable = true;
        signing = {
          key = "A3502B180BC1D41A";
          signByDefault = true;
        };
        ignores = [
          "*~"
          ".DS_Store"
        ];
        settings = {
          user.name = "schererleander";
          user.email = "leander@schererleander.de";
          alias = {
            st = "status";
            co = "checkout";
            br = "branch";
          };
          pull.rebase = true;
          url."git@github.com:".insteadOf = "https://github.com";
        };
      };
      programs.diff-highlight = {
        enable = true;
        enableGitIntegration = true;
      };
    };
  };
}
