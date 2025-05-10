{ config, lib, pkgs, ... }:

let
  cfg = config.git;
in {
  options.git.enable = lib.mkEnableOption "Enable and configure Git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "schererleander";
      userEmail = "leander@schererleander.de";
      extraConfig = {
        alias.co = "checkout";
        alias.br = "branch";
        alias.st = "status";
      };
    };
  };
}