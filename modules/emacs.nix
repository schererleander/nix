{ config, lib, pkgs, ... }:

let 
  cfg = config.emacs;
in {
  options.emacs.enable = lib.mkEnableOption "Enable emacs and setup";
  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
}
