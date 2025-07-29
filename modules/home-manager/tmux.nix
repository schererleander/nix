{ config, lib, pkgs, ... }:

{
  options.tmux.enable = lib.mkEnableOption "Enable and configure Tmux";
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      set -g mouse on
      '';
    };
  };
}