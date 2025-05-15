{ config, lib, pkgs, ... }:

{
  options.git.enable = lib.mkEnableOption "Enable and configure Git";
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "schererleander";
      userEmail = "leander@schererleander.de";
      extraConfig = {
        pull.rebase = true;
        alias.co = "checkout";
        alias.br = "branch";
        alias.st = "status";
      };
    };
  };
}
