{ config, lib, pkgs, ... }:

{
  options.git.enable = lib.mkEnableOption "Enable and configure Git";
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "schererleander";
      userEmail = "leander@schererleander.de";
      extraConfig = {
        user.signingkey = "506793F115464BB4";
        commit.gpgsign  = "true";
        pull.rebase = true;
        alias.co = "checkout";
        alias.br = "branch";
        alias.st = "status";
      };
    };
  };
}
