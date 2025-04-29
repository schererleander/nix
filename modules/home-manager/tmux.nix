{ config, lib, pkgs, ... }:

let
  cfg = config.tmux;
in {
  options.tmux.enable = lib.mkEnableOption "Enable and configure Tmux";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}

