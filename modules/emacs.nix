{ config, lib, pkgs, ... }:

{
  options.emacs.enable = lib.mkEnableOption "Enable emacs and setup";
  config = lib.mkIf config.emacs.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
}