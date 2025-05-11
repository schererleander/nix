{ config, lib, pkgs, ... }:

let
  cfg = config.nixvim;
in {
  options.nixvim.enable = lib.mkEnableOption "Setup nixvim";
  
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
    };
  };
}
