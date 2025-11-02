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
        userName = "schererleander";
        userEmail = "leander@schererleander.de";
        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
        };
        signing = {
          key = "506793F115464BB4";
          signByDefault = true;
        };
        ignores = [
          "*~"
          ".DS_Store"
        ];
        diff-highlight.enable = true;
        extraConfig = {
          pull.rebase = true;
          url."git@github.com:".insteadOf = "https://github.com";
        };
      };
    };
  };
}
