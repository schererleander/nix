{
  config,
  lib,
  ...
}:

{
  options.git.enable = lib.mkEnableOption "Enable git";
  config = lib.mkIf config.git.enable {
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
}
